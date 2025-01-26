extends Node

signal rendered
signal initialized
signal resized


## Scales the viewport size by this factor. Note that projection matrix isn't affected, therefore 
## the result is the same scene rendered but with less resolution.
@export var render_scale: float = 1.0:
	set(value):
		render_scale = value
		if is_initialized:
			_resize(_viewport_size)

var is_initialized: bool = false

const _DEFAULT_TEXTURE_PATH = "res://art/white_1x1.png"

var rd: RenderingDevice
var _pipeline: RID
var _framebuffer: RID
var _framebuffer_attachment_textures: Dictionary = {}
var _mutex: Mutex = Mutex.new()

var _default_texture: RendererTexture
var _sprite_batch: Batch

var _matrix_storage_buffer: RID
var _uniform_projection_matrix: RDUniform

var _viewport_size: Vector2i = Vector2i(512, 512)
var _flush_count = 0
var _texture_manager: TextureManager = TextureManager.new()

enum FramebufferAttachment{
	COLOR,
	UID
}
	
func get_attachment_texture(attachment: FramebufferAttachment) -> RendererTexture:
	return _framebuffer_attachment_textures[attachment]

func begin_frame(viewport_size: Vector2i):
	
	if _viewport_size != viewport_size:
		_resize(viewport_size)
	
	var matrix = _create_orthographic_projection(viewport_size)
	var matrix_data := PackedVector4Array([matrix.x, matrix.y, matrix.z])
	var matrix_bytes: PackedByteArray = matrix_data.to_byte_array()
	rd.buffer_update(_matrix_storage_buffer, 0, matrix_bytes.size(), matrix_bytes)
	_sprite_batch.begin_frame()
	_flush_count = 0

	
func end_frame():
	_sprite_batch.end_frame()
	call_deferred("emit_signal", "rendered")

# Renders a texture that covers the entire framebuffer with a single color
func render_clear(clear_color):
	render_sprite(
		_viewport_size * 0.5,
		_viewport_size,
		0.0,
		clear_color,
		_default_texture,
		0.0
	)

func render_sprite(
	position: Vector2,
	size: Vector2,
	rotation: float,
	color: Color,
	texture: RendererTexture,
	id: float = 0):
	
	if texture == null or not texture.is_valid():
		printerr("Trying to render sprite with invalid texture")
		return
	
	var texture_slot = _texture_manager.get_texture_slot(texture)
	if texture_slot == TextureManager.Status.FULL:
		_sprite_batch.flush()
		_texture_manager.clear()
		texture_slot = _texture_manager.get_texture_slot(texture)
	
	if texture_slot == TextureManager.Status.INVALID:
		printerr("Invalid texture")
		return
	
	_sprite_batch.push_sprite(
		Vector3(position.x, position.y, 1.0),
		size,
		rotation,
		color,
		texture_slot,
		id)

func _enter_tree() -> void:
	_initialize()


# Called when the node enters the scene tree for the first time.
func _initialize() -> void:
	rd = RenderingServer.create_local_rendering_device()
	_texture_manager.rd = rd
	_sprite_batch = load("res://renderer/sprite_batch.gd").new()
	_sprite_batch.rd = rd
	
	if not _sprite_batch.initialize():
		printerr("Error while initializing sprite batch")
		return
	
	# Loads default texture
	var tex = load(_DEFAULT_TEXTURE_PATH)
	_default_texture = RendererTexture.new()
	_default_texture.rd_rid = RenderingCommon.create_local_rd_texture_copy(tex)
	
	var projection_matrix_floats = 12
	_matrix_storage_buffer = rd.storage_buffer_create(
		projection_matrix_floats * 4, 
		[])
	
	_uniform_projection_matrix = RDUniform.new()
	_uniform_projection_matrix.binding = 1
	_uniform_projection_matrix.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	_uniform_projection_matrix.add_id(_matrix_storage_buffer)
	_resize(_viewport_size)
	initialized.emit()
	is_initialized = true


func _resize(viewport_size: Vector2i):
	
	_viewport_size = viewport_size
	
	# Clears the textures
	_framebuffer_attachment_textures.clear()
	
	if rd.framebuffer_is_valid(_framebuffer):
		rd.free_rid(_framebuffer)
		
	if rd.render_pipeline_is_valid(_pipeline):
		rd.free_rid(_pipeline)
	
	# Setup framebuffer ----------------------------------------------------------------------------
	# Creates framebuffer color texture
	var texture_format := RDTextureFormat.new()
	var texture_view := RDTextureView.new()
	texture_format.texture_type = RenderingDevice.TEXTURE_TYPE_2D
	texture_format.width = viewport_size.x * render_scale
	texture_format.height = viewport_size.y * render_scale
	texture_format.format = RenderingDevice.DATA_FORMAT_R32G32B32A32_SFLOAT
	texture_format.usage_bits = (
		RenderingDevice.TEXTURE_USAGE_COLOR_ATTACHMENT_BIT |
		RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT |
		RenderingDevice.TEXTURE_USAGE_STORAGE_BIT)
	var color_texture = RendererTexture.new()
	color_texture.rd_rid = rd.texture_create(
		texture_format, 
		texture_view)
	_framebuffer_attachment_textures[FramebufferAttachment.COLOR] = color_texture
		
	# Creates framebuffer id texture
	var texture_format_id := RDTextureFormat.new()
	texture_format_id.texture_type = RenderingDevice.TEXTURE_TYPE_2D
	texture_format_id.width = viewport_size.x * render_scale
	texture_format_id.height = viewport_size.y * render_scale
	texture_format_id.format = RenderingDevice.DATA_FORMAT_R32_SFLOAT
	texture_format_id.usage_bits = (
		RenderingDevice.TEXTURE_USAGE_COLOR_ATTACHMENT_BIT |
		RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT | 
		RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT |
		RenderingDevice.TEXTURE_USAGE_STORAGE_BIT)
	
	var id_texture = RendererTexture.new()
	id_texture.rd_rid = rd.texture_create(
		texture_format_id,  
		RDTextureView.new())
	_framebuffer_attachment_textures[FramebufferAttachment.UID] = id_texture
	
	# Validates all the framebuffer texture attachments
	for attachment_type in _framebuffer_attachment_textures:
		var attachment_texture: RendererTexture = _framebuffer_attachment_textures[attachment_type]
		if not rd.texture_is_valid(attachment_texture.rd_rid):
			printerr("Framebuffer attachment texture: \"%s\" is invalid" % attachment_type)
			return
	
	# Setup blending for the attachments
	var blend := RDPipelineColorBlendState.new()
	
	# Color blending MIX
	var blend_color_attachment = RDPipelineColorBlendStateAttachment.new()
	blend_color_attachment.enable_blend = true
	blend_color_attachment.color_blend_op = RenderingDevice.BLEND_OP_ADD
	blend_color_attachment.src_color_blend_factor = RenderingDevice.BLEND_FACTOR_SRC_ALPHA
	blend_color_attachment.dst_color_blend_factor = RenderingDevice.BLEND_FACTOR_ONE_MINUS_SRC_ALPHA
	blend_color_attachment.alpha_blend_op = RenderingDevice.BLEND_OP_ADD
	blend_color_attachment.src_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_ONE
	blend_color_attachment.dst_alpha_blend_factor = RenderingDevice.BLEND_FACTOR_ONE_MINUS_SRC_ALPHA
	blend.attachments.push_back(blend_color_attachment)
	
	# ID blending, it doesn't blend
	var blend_id_attachment = RDPipelineColorBlendStateAttachment.new()
	blend_id_attachment.enable_blend = false
	blend.attachments.push_back(blend_id_attachment)
	
	_framebuffer = rd.framebuffer_create(
		_framebuffer_attachment_textures.values().map(
			func(renderer_texture): 
				return renderer_texture.rd_rid)
	)
	
	if not rd.framebuffer_is_valid(_framebuffer):
		printerr("Invalid framebuffer")
		return
	
	# Setup render pipeline ------------------------------------------------------------------------
	_pipeline = rd.render_pipeline_create(
		_sprite_batch.shader,
		rd.framebuffer_get_format(_framebuffer),
		_sprite_batch.vertex_array_format,
		RenderingDevice.RENDER_PRIMITIVE_TRIANGLES,
		RDPipelineRasterizationState.new(),
		RDPipelineMultisampleState.new(),
		RDPipelineDepthStencilState.new(),
		blend)
		
	if not rd.render_pipeline_is_valid(_pipeline):
		printerr("Invalid render pipeline")
		return

	#resized.emit()
	call_deferred("emit_signal", "resized")
	
func _create_orthographic_projection(viewport_size: Vector2) -> Basis:
	var scale_x = 2.0 / viewport_size.x
	var scale_y = 2.0 / viewport_size.y
	var translate_x = -1.0
	var translate_y = -1.0
	return Basis(Vector3(scale_x, 0, 0),
				 Vector3(0, scale_y, 0),
				 Vector3(translate_x, translate_y, 1))


func flush() -> void:
	if not rd.render_pipeline_is_valid(_pipeline):
		return

	_mutex.lock()
	
	
	# Uniforms *************************************************************************************
	var uniforms: Array[RDUniform] = []

	# Create a 2D texture uniform ..................................................................
	var uniform_texture: RDUniform = RDUniform.new()
	uniform_texture.binding = 0 
	uniform_texture.uniform_type = RenderingDevice.UNIFORM_TYPE_SAMPLER_WITH_TEXTURE
	var sampler = RDSamplerState.new()
	var sampler_rd_rid = rd.sampler_create(sampler)
	
	# Adds textures
	for texture_rd_rid in _texture_manager.get_textures_rd_rid():
		uniform_texture.add_id(sampler_rd_rid)
		uniform_texture.add_id(texture_rd_rid)
	
	# Fills reamaining texture slots
	for i in range(32 - _texture_manager.texture_count):
		uniform_texture.add_id(sampler_rd_rid)
		uniform_texture.add_id(_default_texture.rd_rid)
		
	uniforms.append(uniform_texture)

	# Projection matrix ............................................................................
	uniforms.append(_uniform_projection_matrix)

	# Create the uniform set .......................................................................
	var uniform_set_rid = rd.uniform_set_create(uniforms, _sprite_batch.shader, 0)
	
	# The initial colo action changes from `clear` to `keep` if there are multiple flushes
	var intial_color_action = RenderingDevice.INITIAL_ACTION_CLEAR \
							  if _flush_count == 0 \
							  else RenderingDevice.INITIAL_ACTION_KEEP
	var draw_list := rd.draw_list_begin(
		_framebuffer,
		intial_color_action, # Initial color action
		RenderingDevice.FINAL_ACTION_READ,	  # Final color action
		RenderingDevice.INITIAL_ACTION_CLEAR, # Initial depth action
		RenderingDevice.FINAL_ACTION_READ,	  # Final depth action
		
		# Color framebuffer clears with transparent color
		# ID framebuffer clears with black color
		PackedColorArray([Color.TRANSPARENT, Color.BLACK])
	)
	rd.draw_list_bind_uniform_set(draw_list, uniform_set_rid, 0)
	rd.draw_list_bind_render_pipeline(draw_list, _pipeline)
	rd.draw_list_bind_vertex_array(draw_list, _sprite_batch.vertex_array)
	rd.draw_list_bind_index_array(draw_list, _sprite_batch.index_array)
	rd.draw_list_draw(draw_list, true, 1)
	rd.draw_list_end()
	rd.submit()
	rd.sync()
	rd.free_rid(uniform_set_rid)
	rd.free_rid(sampler_rd_rid)
	_mutex.unlock()
	
	_flush_count += 1
