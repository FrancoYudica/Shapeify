extends RefCounted

const LOCAL_SIZE_X: int = 64

# Everything after this point is designed to run on our rendering thread.
var _rd: RenderingDevice
var _shader: RID
var _pipeline: RID


var _input_uniform: RDUniform
var _input_storage_buffer: RID

var _output_uniform: RDUniform
var _output_storage_buffer: RID

var _uniform_set_rid: RID

func compute(input_storage_buffer, size) -> float:
	
	var workgroup_size_x = max(size / 64, 1)
	_input_uniform.clear_ids()
	_input_uniform.add_id(input_storage_buffer)

	var uniform_set_rid = _rd.uniform_set_create([_input_uniform, _output_uniform], _shader, 0)

	# Run our compute _shader.
	var compute_list := _rd.compute_list_begin()
	_rd.compute_list_bind_compute_pipeline(compute_list, _pipeline)
	_rd.compute_list_bind_uniform_set(compute_list, uniform_set_rid, 0)
	_rd.compute_list_dispatch(
		compute_list, 
		workgroup_size_x, 
		1, 
		1)
	_rd.compute_list_end()
	_rd.submit()
	_rd.sync()
	# Gets compute output. Note that buffer_get_data causes stall
	var output_bytes = _rd.buffer_get_data(_output_storage_buffer, 0, workgroup_size_x * 4)
	
	var result_array = output_bytes.to_float32_array()
	var sum = 0.0
	for n in result_array:
		sum += n
	return sum

func _init() -> void:
	_initialize_compute_code()
	

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		_rd.free_rid(_pipeline)
		_rd.free_rid(_shader)


func _load_shader():
	_rd = Renderer.rd

	# Create our _shader.
	var shader_file := load("res://shaders/compute/sum_ubo.glsl")
	var shader_spirv: RDShaderSPIRV = shader_file.get_spirv()
	_shader = _rd.shader_create_from_spirv(shader_spirv)
	_pipeline = _rd.compute_pipeline_create(_shader)

func _initialize_compute_code() -> void:

	_load_shader()

	# Uniform where results are stored
	_input_uniform = RDUniform.new()
	_input_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	_input_uniform.binding = 0

	# Uniform where results are stored
	_output_uniform = RDUniform.new()
	_output_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	_output_uniform.binding = 1

	# The output storage buffer only holds one value
	var bytes = PackedByteArray()
	bytes.resize(4 * 1000000)
	bytes.fill(0)
	_output_storage_buffer = _rd.storage_buffer_create(
		bytes.size(),
		bytes)
	_output_uniform.add_id(_output_storage_buffer)
	
