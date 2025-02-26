class_name LocalRenderer extends RefCounted

var _pipeline: RID
var _framebuffer: RID
var _framebuffer_attachment_textures: Dictionary = {}

var _default_texture: LocalTexture
var _batch: RendererBatch

var _matrix_storage_buffer: RID
var _uniform_projection_matrix: RDUniform

var _viewport_size: Vector2i = Vector2i(512, 512)
var _flush_count = 0
var _texture_manager := LocalTextureManager.new()
var rd: RenderingDevice

enum FramebufferAttachment{
	COLOR,
	UID
}

var is_valid: bool:
	get:
		return _pipeline.is_valid() and rd.render_pipeline_is_valid(_pipeline)

func get_attachment_texture(attachment: FramebufferAttachment) -> LocalTexture:
	return _framebuffer_attachment_textures[attachment]

func begin_frame(viewport_size: Vector2i):
	
	if _viewport_size != viewport_size:
		_resize(viewport_size)
	
	_batch.begin_frame()
	_flush_count = 0
	
func end_frame():
	_batch.end_frame()

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
	texture: Texture2D,
	id: float = 0):
	
	if texture == null:
		printerr("Trying to render sprite with invalid texture")
		return
	
	# Gets local texture
	var local_texture = _texture_manager.get_local_texture(texture)
	
	# LocalTexture cache is full. Needs to render before adding more textures
	if local_texture == null:
		_batch.flush()
		_texture_manager.clear_cached_textures()
		local_texture = _texture_manager.get_local_texture(texture)
	
	# Gets texture slot
	var texture_slot = _texture_manager.get_local_texture_slot(local_texture)
	
	if texture_slot == LocalTextureManager.Status.FULL:
		_batch.flush()
		_texture_manager.clear()
		texture_slot = _texture_manager.get_local_texture_slot(local_texture)
	
	_batch.push_sprite(
		Vector3(position.x, position.y, 1.0),
		size,
		rotation,
		color,
		texture_slot,
		id)


func initialize(local_rd: RenderingDevice) -> void:
	
	# Sets the rendering device
	if local_rd == null:
		rd = RenderingServer.get_rendering_device()
	else:
		rd = local_rd
	
	# Creates batch
	_batch = load("res://rendering/local_renderer/sprite_batch.gd").new()

	# Sets up renderign device references
	_texture_manager.rd = rd
	_batch.rd = rd
	_batch.local_renderer = self
	
	if not _batch.initialize():
		printerr("Error while initializing batch")
		return
	
	# Loads default texture
	var default_image := Image.create(1, 1, false, Image.Format.FORMAT_RGBA8)
	default_image.fill(Color.WHITE)
	_default_texture = LocalTexture.load_from_image(default_image, rd)
	
	var projection_matrix_floats = 12
	_matrix_storage_buffer = rd.storage_buffer_create(
		projection_matrix_floats * 4, 
		[])
	
	_uniform_projection_matrix = RDUniform.new()
	_uniform_projection_matrix.binding = 1
	_uniform_projection_matrix.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	_uniform_projection_matrix.add_id(_matrix_storage_buffer)
	_resize(_viewport_size)

func _resize(viewport_size: Vector2i):
	
	_viewport_size = viewport_size

	var matrix = _create_orthographic_projection(viewport_size)
	var matrix_data := PackedVector4Array([matrix.x, matrix.y, matrix.z])
	var matrix_bytes: PackedByteArray = matrix_data.to_byte_array()
	rd.buffer_update(_matrix_storage_buffer, 0, matrix_bytes.size(), matrix_bytes)

	# Clears the textures
	_framebuffer_attachment_textures.clear()
	
	if rd.framebuffer_is_valid(_framebuffer):
		rd.free_rid(_framebuffer)
		
	if rd.render_pipeline_is_valid(_pipeline):
		rd.free_rid(_pipeline)
	
	# Setup framebuffer ----------------------------------------------------------------------------
	# Creates framebuffer color texture
	var texture_format := RDTextureFormat.new()
	texture_format.texture_type = RenderingDevice.TEXTURE_TYPE_2D
	texture_format.width = viewport_size.x
	texture_format.height = viewport_size.y
	texture_format.format = RenderingDevice.DATA_FORMAT_R8G8B8A8_UNORM
	texture_format.usage_bits = (
		RenderingDevice.TEXTURE_USAGE_COLOR_ATTACHMENT_BIT |
		RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT |
		RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT |
		RenderingDevice.TEXTURE_USAGE_STORAGE_BIT)
	var color_texture = LocalTexture.create_empty(texture_format, rd)
	_framebuffer_attachment_textures[FramebufferAttachment.COLOR] = color_texture
		
	# Creates framebuffer id texture
	var id_texture_format := RDTextureFormat.new()
	id_texture_format.texture_type = RenderingDevice.TEXTURE_TYPE_2D
	id_texture_format.width = viewport_size.x
	id_texture_format.height = viewport_size.y
	id_texture_format.format = RenderingDevice.DATA_FORMAT_R32_SFLOAT
	id_texture_format.usage_bits = (
		RenderingDevice.TEXTURE_USAGE_COLOR_ATTACHMENT_BIT |
		RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT | 
		RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT |
		RenderingDevice.TEXTURE_USAGE_STORAGE_BIT)
	
	var id_texture = LocalTexture.create_empty(id_texture_format, rd)
	_framebuffer_attachment_textures[FramebufferAttachment.UID] = id_texture
	
	# Validates all the framebuffer texture attachments
	for attachment_type in _framebuffer_attachment_textures:
		var attachment_texture: LocalTexture = _framebuffer_attachment_textures[attachment_type]
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
		_batch.shader,
		rd.framebuffer_get_format(_framebuffer),
		_batch.vertex_array_format,
		RenderingDevice.RENDER_PRIMITIVE_TRIANGLES,
		RDPipelineRasterizationState.new(),
		RDPipelineMultisampleState.new(),
		RDPipelineDepthStencilState.new(),
		blend)
		
	if not rd.render_pipeline_is_valid(_pipeline):
		printerr("Invalid render pipeline")
		return

func _create_orthographic_projection(viewport_size: Vector2) -> Basis:
	var scale_x = 2.0 / viewport_size.x
	var scale_y = 2.0 / viewport_size.y
	var translate_x = -1.0
	var translate_y = -1.0
	return Basis(Vector3(scale_x, 0, 0),
				 Vector3(0, scale_y, 0),
				 Vector3(translate_x, translate_y, 1))

func delete() -> void:
	rd.free_rid(_pipeline)
	rd.free_rid(_framebuffer)
	rd.free_rid(_matrix_storage_buffer)
	_batch.delete()
	_texture_manager.clear()

func flush() -> void:
	if not rd.render_pipeline_is_valid(_pipeline):
		return
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
	var uniform_set_rid = rd.uniform_set_create(uniforms, _batch.shader, 0)
	
	# The initial color action changes from `clear` to `keep` if there are multiple flushes
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
	rd.draw_list_bind_vertex_array(draw_list, _batch.vertex_array)
	rd.draw_list_bind_index_array(draw_list, _batch.index_array)
	rd.draw_list_draw(draw_list, true, 1)
	rd.draw_list_end()
	
	# Only submits and syncs if it's using a local rendering device
	if rd != RenderingServer.get_rendering_device():
		rd.submit()
		rd.sync()
		
	rd.free_rid(uniform_set_rid)
	rd.free_rid(sampler_rd_rid)
	
	_flush_count += 1
