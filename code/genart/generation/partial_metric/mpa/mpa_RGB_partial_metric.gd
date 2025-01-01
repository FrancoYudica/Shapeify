extends MPAPartialMetric

const LOCAL_SIZE_X: int = 256
var BUFFER_DATA_COUNT: int = Constants.MAX_COMPUTE_BUFFER_SIZE

# Everything after this point is designed to run on our rendering thread.
var _rd: RenderingDevice
var _shader: RID
var _pipeline: RID

# Uniform that holds the result
var _input_uniform: RDUniform
var _input_storage_buffer: RID

var _uniform_set_rid: RID

## Textures and texture sets
var _target_texture_set_rid: RID
var _source_texture_set_rid: RID
var _new_source_texture_set_rid: RID


var _mpa_metric: MPAMetric
var _global_metric_value: float
var _global_value_invalidated: bool = true

func _target_texture_set():
	
	if _target_texture_set_rid.is_valid():
		_rd.free_rid(_target_texture_set_rid)
	
	_target_texture_set_rid = _create_texture_uniform_set(target_texture.rd_rid, 1)
	_mpa_metric.target_texture = target_texture
	_global_value_invalidated = true

func _source_texture_set():
	
	if _source_texture_set_rid.is_valid():
		_rd.free_rid(_source_texture_set_rid)
	
	_source_texture_set_rid = _create_texture_uniform_set(source_texture.rd_rid, 2)
	_global_value_invalidated = true

func _new_source_texture_set():
	
	if _new_source_texture_set_rid.is_valid():
		_rd.free_rid(_new_source_texture_set_rid)
	
	_new_source_texture_set_rid = _create_texture_uniform_set(new_source_texture.rd_rid, 3)


func _compute(subrect: Rect2i) -> float:
	
	# Calculates the global MPA value
	if _global_value_invalidated:
		_mpa_metric.power = power
		_global_metric_value = _mpa_metric.compute(source_texture)
		_global_value_invalidated = false
	
	var sample_texture_width = subrect.size.x
	var sample_texture_height = subrect.size.y
	var pixel_count = sample_texture_width * sample_texture_height
	
	var workgroup_size_x = ceili(float(pixel_count) / LOCAL_SIZE_X)
	
	var push_constant := PackedFloat32Array([
		# Vec2 texture size
		target_texture.get_width(),
		target_texture.get_height(),

		# Sample size
		sample_texture_width,
		sample_texture_height,
		
		# Sample offset
		subrect.position.x,
		subrect.position.y,
		
		power,
		0.0
	])

	var push_constant_byte_array = push_constant.to_byte_array()
	# Run our compute _shader.
	var compute_list := _rd.compute_list_begin()
	_rd.compute_list_bind_compute_pipeline(compute_list, _pipeline)
	_rd.compute_list_bind_uniform_set(compute_list, _uniform_set_rid, 0)
	_rd.compute_list_bind_uniform_set(compute_list, _target_texture_set_rid, 1)
	_rd.compute_list_bind_uniform_set(compute_list, _source_texture_set_rid, 2)
	_rd.compute_list_bind_uniform_set(compute_list, _new_source_texture_set_rid, 3)
	_rd.compute_list_set_push_constant(compute_list, push_constant_byte_array, push_constant_byte_array.size())
	_rd.compute_list_dispatch(
		compute_list, 
		workgroup_size_x, 
		1, 
		1)
	_rd.compute_list_end()
	
	# Gets the results stored in the input buffer
	var result_bytes = _rd.buffer_get_data(_input_storage_buffer, 0, workgroup_size_x * 4)
	var partial_sums = result_bytes.to_float32_array()
	var delta_mpa_sum = 0
	for n in partial_sums:
		delta_mpa_sum += n
		
	var delta_mpa = delta_mpa_sum / (target_texture.get_width() * target_texture.get_height() * 3.0)

	var mpa = _global_metric_value + delta_mpa
	return mpa

func _init() -> void:
	_initialize_compute_code()
	metric_name = "MPA RGB Partial"
	_mpa_metric = load("res://generation/metric/mpa/mpa_RGB_metric.gd").new()
	

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		_rd.free_rid(_target_texture_set_rid)
		_rd.free_rid(_source_texture_set_rid)
		_rd.free_rid(_new_source_texture_set_rid)
		_rd.free_rid(_pipeline)
		_rd.free_rid(_shader)


func _load_shader():
	_rd = Renderer.rd

	# Create our _shader.
	var shader_file := load("res://shaders/compute/partial_metric/mpa_rgb_partial.glsl")
	var shader_spirv: RDShaderSPIRV = shader_file.get_spirv()
	_shader = _rd.shader_create_from_spirv(shader_spirv)
	_pipeline = _rd.compute_pipeline_create(_shader)

func _initialize_compute_code() -> void:

	_load_shader()
	
	# Input uniform where shared data is stored
	_input_uniform = RDUniform.new()
	_input_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	_input_uniform.binding = 0

	var input_bytes = PackedByteArray()
	input_bytes.resize(BUFFER_DATA_COUNT * 4)
	input_bytes.fill(0)
	_input_storage_buffer = _rd.storage_buffer_create(
		input_bytes.size(),
		input_bytes)
	_input_uniform.add_id(_input_storage_buffer)
	
	# Cretates uniform set in set = 0
	_uniform_set_rid = _rd.uniform_set_create([_input_uniform], _shader, 0)


## Creates an uniform set containing the texture
func _create_texture_uniform_set(
	texture_rid: RID, 
	set_index: int) -> RID:
		
	# Creates the texture uniform
	var image_uniform := RDUniform.new()
	image_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	image_uniform.binding = 0
	image_uniform.add_id(texture_rid)
	
	# Creates texture set
	var uniform_texture_set_rid = _rd.uniform_set_create([image_uniform], _shader, set_index)
	return uniform_texture_set_rid
