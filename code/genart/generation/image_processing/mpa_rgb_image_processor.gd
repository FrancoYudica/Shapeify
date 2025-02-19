class_name MPAImageProcessor extends ImageProcessor

const LOCAL_SIZE = 32

var power = 4.0

var _texture_target_uniform: RDUniform
var _texture_src_uniform: RDUniform
var _texture_output_uniform: RDUniform

var _target_texture: RendererTexture
var src_texture: RendererTexture
var _output_texture: RendererTexture

var _texture_target_set_rid: RID
var _texture_src_set_rid: RID
var _texture_output_set_rid: RID

var _rd: RenderingDevice

var _shader: RID
var _pipeline: RID


func process_image(texture: RendererTexture) -> RendererTexture:
	
	if texture == null:
		push_error("Given texture is null")
		return null

	if src_texture == null:
		push_error("src_texture is null")
		return null
		
	if texture.get_size() != src_texture.get_size():
		push_error("Target texture and source texture doesn't match")
		return null
	
	_refresh_textures(texture)

	var texture_width = texture.get_width()
	var texture_height = texture.get_height()
	
	var workgroup_size_x = ceili(float(texture_width) / LOCAL_SIZE)
	var workgroup_size_y = ceili(float(texture_height) / LOCAL_SIZE)
	var push_constant := PackedFloat32Array([
		# Vec2 texture size
		texture_width,
		texture_height,
		power,
		0.0
	])

	var push_constant_byte_array = push_constant.to_byte_array()
	# Run our compute _shader.
	var compute_list := _rd.compute_list_begin()
	_rd.compute_list_bind_compute_pipeline(compute_list, _pipeline)
	_rd.compute_list_bind_uniform_set(compute_list, _texture_target_set_rid, 0)
	_rd.compute_list_bind_uniform_set(compute_list, _texture_src_set_rid, 1)
	_rd.compute_list_bind_uniform_set(compute_list, _texture_output_set_rid, 2)
	_rd.compute_list_set_push_constant(compute_list, push_constant_byte_array, push_constant_byte_array.size())
	_rd.compute_list_dispatch(
		compute_list, 
		workgroup_size_x, 
		workgroup_size_y, 
		1)
	_rd.compute_list_end()
	_rd.submit()
	_rd.sync()

	return _output_texture

func _init() -> void:
	_rd = Renderer.rd

	# Create our _shader.
	var shader_file := load("res://shaders/compute/image_processing/mpa_rgb.glsl")
	var shader_spirv: RDShaderSPIRV = shader_file.get_spirv()
	_shader = _rd.shader_create_from_spirv(shader_spirv)
	_pipeline = _rd.compute_pipeline_create(_shader)
	
	# Creates the texture uniforms
	_texture_target_uniform = RDUniform.new()
	_texture_target_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	_texture_target_uniform.binding = 0
	_texture_src_uniform = RDUniform.new()
	_texture_src_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	_texture_src_uniform.binding = 0
	_texture_output_uniform = RDUniform.new()
	_texture_output_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	_texture_output_uniform.binding = 0
	

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		if _texture_target_set_rid.is_valid() and _rd.uniform_set_is_valid(_texture_target_set_rid):
			_rd.free_rid(_texture_target_set_rid)
		if _texture_src_set_rid.is_valid() and _rd.uniform_set_is_valid(_texture_src_set_rid):
			_rd.free_rid(_texture_src_set_rid)
		if _texture_output_set_rid.is_valid() and _rd.uniform_set_is_valid(_texture_output_set_rid):
			_rd.free_rid(_texture_output_set_rid)
		_rd.free_rid(_pipeline)
		_rd.free_rid(_shader)


var _previous_texture_rid: RID

func _refresh_textures(texture: RendererTexture):
	
	# Uniform sets and textures already initialized
	if texture.rd_rid == _previous_texture_rid:
		return
	
	_target_texture = texture.copy()
	_output_texture = texture.copy()

	_texture_target_uniform.clear_ids()
	_texture_src_uniform.clear_ids()
	_texture_output_uniform.clear_ids()
	
	_texture_target_uniform.add_id(_target_texture.rd_rid)
	_texture_src_uniform.add_id(src_texture.rd_rid)
	_texture_output_uniform.add_id(_output_texture.rd_rid)
	
	if _texture_target_set_rid.is_valid() and _rd.uniform_set_is_valid(_texture_target_set_rid):
		_rd.free_rid(_texture_target_set_rid)
	if _texture_src_set_rid.is_valid() and _rd.uniform_set_is_valid(_texture_src_set_rid):
		_rd.free_rid(_texture_src_set_rid)
	if _texture_output_set_rid.is_valid() and _rd.uniform_set_is_valid(_texture_output_set_rid):
		_rd.free_rid(_texture_output_set_rid)

	_texture_target_set_rid = _rd.uniform_set_create([_texture_target_uniform], _shader, 0)
	_texture_src_set_rid = _rd.uniform_set_create([_texture_src_uniform], _shader, 1)
	_texture_output_set_rid = _rd.uniform_set_create([_texture_output_uniform], _shader, 2)
