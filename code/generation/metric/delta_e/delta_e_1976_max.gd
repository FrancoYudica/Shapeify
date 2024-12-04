extends DeltaEMetric

# Everything after this point is designed to run on our rendering thread.
var _rd: RenderingDevice
var _shader: RID
var _pipeline: RID

# Uniform that holds the result
var _output_uniform: RDUniform

## Textures and texture sets
var _target_texture_set_rid: RID
var _source_texture_set_rid: RID

# Array where the calculations results are stored
var _result_bytes := PackedByteArray()

func _target_texture_set():
	
	if _target_texture_set_rid.is_valid() and _rd.uniform_set_is_valid(_target_texture_set_rid):
		_rd.free_rid(_target_texture_set_rid)
	
	_target_texture_set_rid = _create_texture_uniform_set(target_texture.rd_rid, 1)

var _previous_source_texture_rd_rid: RID

func _compute(source_texture: RendererTexture) -> float:
	
	# This avoids creating new uniform sets when source texture is the same
	if _previous_source_texture_rd_rid != source_texture.rd_rid:
		
		if _source_texture_set_rid.is_valid() and _rd.uniform_set_is_valid(_source_texture_set_rid):
			_rd.free_rid(_source_texture_set_rid)
		_previous_source_texture_rd_rid = source_texture.rd_rid
		_source_texture_set_rid = _create_texture_uniform_set(source_texture.rd_rid, 2)
	
	var texture_width =  target_texture.get_width()
	var texture_height = target_texture.get_height()
	
	var group_size_x = texture_width
	var group_size_y = texture_height
	var local_size = 8
	
	var workgroup_count_x = ceili(float(group_size_x) / local_size)
	var workgroup_count_y = ceili(float(group_size_y) / local_size)
	var workgroup_count = workgroup_count_x * workgroup_count_y
	# Creates the buffer, that will hold the actual data that the CPU will send to the GPU
	var result_float_array = PackedFloat32Array()
	
	# Array that stores the max delta e for each work group
	result_float_array.resize(workgroup_count)
	result_float_array.fill(0.0)
		
	_result_bytes = result_float_array.to_byte_array()
	
	# Ensures synchronization, since the execute_compute function also uses
	var storage_buffer_result_rid = _rd.storage_buffer_create(
		_result_bytes.size(),
		_result_bytes)
		
	_output_uniform.add_id(storage_buffer_result_rid)
	
	var uniform_set_rid = _rd.uniform_set_create([_output_uniform], _shader, 0)
	
	var push_constant := PackedFloat32Array([
		# Vec2 texture size
		texture_width,
		texture_height,
		0.0, 0.0
	])
	
	var push_constant_byte_array = push_constant.to_byte_array()
	# Run our compute _shader.
	var compute_list := _rd.compute_list_begin()
	_rd.compute_list_bind_compute_pipeline(compute_list, _pipeline)
	_rd.compute_list_bind_uniform_set(compute_list, uniform_set_rid, 0)
	_rd.compute_list_bind_uniform_set(compute_list, _target_texture_set_rid, 1)
	_rd.compute_list_bind_uniform_set(compute_list, _source_texture_set_rid, 2)
	_rd.compute_list_set_push_constant(compute_list, push_constant_byte_array, push_constant_byte_array.size())
	_rd.compute_list_dispatch(
		compute_list, 
		workgroup_count_x,
		workgroup_count_y,
		1)
	_rd.compute_list_end()
	
	# Gets compute output. Note that buffer_get_data causes stall
	var output_bytes = _rd.buffer_get_data(storage_buffer_result_rid)
	var output = output_bytes.to_float32_array()
	var max_delta_e = 0.0
	for i in range(workgroup_count):
		max_delta_e = maxf(output[i], max_delta_e)
	
	# Frees resouces
	_rd.free_rid(storage_buffer_result_rid)

	_output_uniform.clear_ids()
	
	return max_delta_e

func _init() -> void:
	RenderingServer.call_on_render_thread(_initialize_compute_code)
	metric_name = "Max Delta E 1976"

func _exit_tree() -> void:
	_rd.free_rid(_shader)

func _load_shader():
	_rd = Renderer.rd

	# Create our _shader.
	var shader_file := load("res://shaders/compute/metric/deltaE/deltaE_1976_max.glsl")
	var shader_spirv: RDShaderSPIRV = shader_file.get_spirv()
	_shader = _rd.shader_create_from_spirv(shader_spirv)
	_pipeline = _rd.compute_pipeline_create(_shader)

func _initialize_compute_code() -> void:

	_load_shader()
	
	# Uniform where results are stored
	_output_uniform = RDUniform.new()
	_output_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	_output_uniform.binding = 0
	

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
