class_name MultiplyImageProcessor extends ImageProcessor

const LOCAL_SIZE = 32

var multiply_value: float = 1

var _texture_input_uniform: RDUniform
var _texture_output_uniform: RDUniform

var _texture_input: RendererTexture
var _texture_output: RendererTexture

var _texture_input_set_rid: RID
var _texture_output_set_rid: RID

var _rd: RenderingDevice

var _shader: RID
var _pipeline: RID


func process_image(texture: RendererTexture) -> RendererTexture:
	
	_refresh_textures(texture)

	var texture_width = _texture_input.get_width()
	var texture_height = _texture_input.get_height()
	
	var workgroup_size_x = ceili(float(texture_width) / LOCAL_SIZE)
	var workgroup_size_y = ceili(float(texture_height) / LOCAL_SIZE)
	var push_constant := PackedFloat32Array([
		# Vec2 texture size
		texture_width,
		texture_height,
		multiply_value,
		0.0
	])

	var push_constant_byte_array = push_constant.to_byte_array()
	# Run our compute _shader.
	var compute_list := _rd.compute_list_begin()
	_rd.compute_list_bind_compute_pipeline(compute_list, _pipeline)
	_rd.compute_list_bind_uniform_set(compute_list, _texture_input_set_rid, 0)
	_rd.compute_list_bind_uniform_set(compute_list, _texture_output_set_rid, 1)
	_rd.compute_list_set_push_constant(compute_list, push_constant_byte_array, push_constant_byte_array.size())
	_rd.compute_list_dispatch(
		compute_list, 
		workgroup_size_x, 
		workgroup_size_y, 
		1)
	_rd.compute_list_end()
	_rd.submit()
	_rd.sync()

	return _texture_output

func _init() -> void:
	_rd = Renderer.rd

	# Create our _shader.
	var shader_file := load("res://shaders/compute/image_processing/multiply.glsl")
	var shader_spirv: RDShaderSPIRV = shader_file.get_spirv()
	_shader = _rd.shader_create_from_spirv(shader_spirv)
	_pipeline = _rd.compute_pipeline_create(_shader)
	
	# Creates the texture uniforms
	_texture_input_uniform = RDUniform.new()
	_texture_input_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	_texture_input_uniform.binding = 0
	_texture_output_uniform = RDUniform.new()
	_texture_output_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	_texture_output_uniform.binding = 0
	

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		if _texture_input_set_rid.is_valid() and _rd.uniform_set_is_valid(_texture_input_set_rid):
			_rd.free_rid(_texture_input_set_rid)
		if _texture_output_set_rid.is_valid() and _rd.uniform_set_is_valid(_texture_output_set_rid):
			_rd.free_rid(_texture_output_set_rid)
		_rd.free_rid(_pipeline)
		_rd.free_rid(_shader)


var _previous_texture_rid: RID

func _refresh_textures(texture: RendererTexture):
	
	# Uniform sets and textures already initialized
	if texture.rd_rid == _previous_texture_rid:
		return
	
	_texture_input = texture.copy()
	_texture_output = texture.copy()

	_texture_input_uniform.clear_ids()
	_texture_output_uniform.clear_ids()
	
	_texture_input_uniform.add_id(_texture_input.rd_rid)
	_texture_output_uniform.add_id(_texture_output.rd_rid)
	
	if _texture_input_set_rid.is_valid() and _rd.uniform_set_is_valid(_texture_input_set_rid):
		_rd.free_rid(_texture_input_set_rid)
	if _texture_output_set_rid.is_valid() and _rd.uniform_set_is_valid(_texture_output_set_rid):
		_rd.free_rid(_texture_output_set_rid)
	
	_texture_input_set_rid = _rd.uniform_set_create([_texture_input_uniform], _shader, 0)
	_texture_output_set_rid = _rd.uniform_set_create([_texture_output_uniform], _shader, 1)
