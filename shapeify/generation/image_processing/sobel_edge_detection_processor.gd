class_name SobelEdgeDetectionImageProcessor extends ImageProcessor

const LOCAL_SIZE = 32

var threshold: float = 0.0
var power: float = 1.0

var _texture_a_uniform: RDUniform
var _texture_b_uniform: RDUniform

var _texture_a: LocalTexture
var _texture_b: LocalTexture

var _texture_a_set_rid: RID
var _texture_b_set_rid: RID

var _rd: RenderingDevice

var _shader: RID
var _pipeline: RID

var _last_texture_rd_rid: RID

func process_image(texture: LocalTexture) -> LocalTexture:
	
	if texture.rd_rid != _last_texture_rd_rid:
		_refresh_textures(texture)
		_last_texture_rd_rid = texture.rd_rid
		
	var texture_width = _texture_a.get_width()
	var texture_height = _texture_a.get_height()
	
	var workgroup_size_x = ceili(float(texture_width) / LOCAL_SIZE)
	var workgroup_size_y = ceili(float(texture_height) / LOCAL_SIZE)
	
	var push_constant := PackedFloat32Array([
		threshold,
		power,
		0.0,
		0.0,
	])

	var push_constant_byte_array = push_constant.to_byte_array()
	# Run our compute _shader.
	var compute_list := _rd.compute_list_begin()
	_rd.compute_list_bind_compute_pipeline(compute_list, _pipeline)
	_rd.compute_list_bind_uniform_set(compute_list, _texture_a_set_rid, 0)
	_rd.compute_list_bind_uniform_set(compute_list, _texture_b_set_rid, 1)
	_rd.compute_list_set_push_constant(compute_list, push_constant_byte_array, push_constant_byte_array.size())
	_rd.compute_list_dispatch(
		compute_list, 
		workgroup_size_x, 
		workgroup_size_y, 
		1)
	_rd.compute_list_end()
	_rd.submit()
	_rd.sync()

	return _texture_b

func _init() -> void:
	_rd = GenerationGlobals.renderer.rd

	# Create our _shader.
	var shader_file := load("res://shaders/compute/image_processing/sobel_edge_detection.glsl")
	var shader_spirv: RDShaderSPIRV = shader_file.get_spirv()
	_shader = _rd.shader_create_from_spirv(shader_spirv)
	_pipeline = _rd.compute_pipeline_create(_shader)
	
	# Creates the texture uniforms
	_texture_a_uniform = RDUniform.new()
	_texture_a_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	_texture_a_uniform.binding = 0
	_texture_b_uniform = RDUniform.new()
	_texture_b_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	_texture_b_uniform.binding = 0
	

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		if _texture_a_set_rid.is_valid() and _rd.uniform_set_is_valid(_texture_a_set_rid):
			_rd.free_rid(_texture_a_set_rid)
		if _texture_b_set_rid.is_valid() and _rd.uniform_set_is_valid(_texture_b_set_rid):
			_rd.free_rid(_texture_b_set_rid)
		_rd.free_rid(_pipeline)
		_rd.free_rid(_shader)


func _refresh_textures(texture: LocalTexture):
	_texture_a = texture.copy()
	_texture_b = texture.copy()
	
	_texture_a_uniform.clear_ids()
	_texture_b_uniform.clear_ids()

	_texture_a_uniform.add_id(_texture_a.rd_rid)
	_texture_b_uniform.add_id(_texture_b.rd_rid)

	if _texture_a_set_rid.is_valid() and _rd.uniform_set_is_valid(_texture_a_set_rid):
		_rd.free_rid(_texture_a_set_rid)
	if _texture_b_set_rid.is_valid() and _rd.uniform_set_is_valid(_texture_b_set_rid):
		_rd.free_rid(_texture_b_set_rid)

	_texture_a_set_rid = _rd.uniform_set_create([_texture_a_uniform], _shader, 0)
	_texture_b_set_rid = _rd.uniform_set_create([_texture_b_uniform], _shader, 1)
