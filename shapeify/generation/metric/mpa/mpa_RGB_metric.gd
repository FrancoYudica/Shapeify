extends MPAMetric

# Everything after this point is designed to run on our rendering thread.
var _rd: RenderingDevice
var _shader: RID
var _pipeline: RID

# Uniform that holds the result
var _output_uniform: RDUniform
var _output_storage_buffer: RID

var _weights_uniform: RDUniform
var _weights_storage_buffer: RID

var _uniform_set_rid: RID

## Textures and texture sets
var _target_texture_set_rid: RID
var _source_texture_set_rid: RID
var _weight_texture_set_rid: RID

func _target_texture_set():
	
	if _target_texture_set_rid.is_valid():
		_rd.free_rid(_target_texture_set_rid)
	
	_target_texture_set_rid = _create_texture_uniform_set(target_texture.rd_rid, 1)

func _weight_texture_set():
	
	if _weight_texture_set_rid.is_valid() and _rd.uniform_set_is_valid(_weight_texture_set_rid):
		_rd.free_rid(_weight_texture_set_rid)
	
	_weight_texture_set_rid = _create_texture_uniform_set(weight_texture.rd_rid, 3)

var _previous_source_texture_rd_rid: RID

func _compute(source_texture: LocalTexture) -> float:
	
	# This avoids creating new uniform sets when source texture is the same
	if _previous_source_texture_rd_rid != source_texture.rd_rid:
		
		if _source_texture_set_rid.is_valid() and _rd.uniform_set_is_valid(_source_texture_set_rid):
			_rd.free_rid(_source_texture_set_rid)
		_previous_source_texture_rd_rid = source_texture.rd_rid
		_source_texture_set_rid = _create_texture_uniform_set(source_texture.rd_rid, 2)
	
	var texture_width =  target_texture.get_width()
	var texture_height = target_texture.get_height()
	var pixel_count = texture_width * texture_height
	
	var local_size_x = 256
	var workgroup_size_x = ceili(float(pixel_count) / local_size_x)
	
	var push_constant := PackedFloat32Array([
		# Vec2 texture size
		texture_width,
		texture_height,
		power, 0.0
	])
	
	var push_constant_byte_array = push_constant.to_byte_array()
	# Run our compute _shader.
	var compute_list := _rd.compute_list_begin()
	_rd.compute_list_bind_compute_pipeline(compute_list, _pipeline)
	_rd.compute_list_bind_uniform_set(compute_list, _uniform_set_rid, 0)
	_rd.compute_list_bind_uniform_set(compute_list, _target_texture_set_rid, 1)
	_rd.compute_list_bind_uniform_set(compute_list, _source_texture_set_rid, 2)
	_rd.compute_list_bind_uniform_set(compute_list, _weight_texture_set_rid, 3)
	_rd.compute_list_set_push_constant(compute_list, push_constant_byte_array, push_constant_byte_array.size())
	_rd.compute_list_dispatch(
		compute_list, 
		workgroup_size_x, 
		1, 
		1)
	_rd.compute_list_end()
	
	# Gets compute output. Note that buffer_get_data causes stall
	var output_bytes = _rd.buffer_get_data(_output_storage_buffer, 0, workgroup_size_x * 4)
	var partial_sums = output_bytes.to_float32_array()
	var mpa_sum: float = 0.0
	for n in partial_sums:
		mpa_sum += n
	
	var weights_output_bytes = _rd.buffer_get_data(_weights_storage_buffer, 0, workgroup_size_x * 4)
	var weights_partial_sums = weights_output_bytes.to_float32_array()
	var total_weights: float = 0.0
	for n in weights_partial_sums:
		total_weights += n
	var mpa = mpa_sum / (total_weights * 3.0)
	return mpa

func _init() -> void:
	_initialize_compute_code()
	metric_name = "MPA RGB"

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		_rd.free_rid(_output_storage_buffer)
		_rd.free_rid(_weights_storage_buffer)
		_rd.free_rid(_target_texture_set_rid)
		_rd.free_rid(_source_texture_set_rid)
		_rd.free_rid(_weight_texture_set_rid)
		_rd.free_rid(_pipeline)
		_rd.free_rid(_shader)


func _load_shader():
	_rd = GenerationGlobals.renderer.rd

	# Create our _shader.
	var shader_file := load("res://shaders/compute/metric/mpa/mpa_rgb.glsl")
	var shader_spirv: RDShaderSPIRV = shader_file.get_spirv()
	_shader = _rd.shader_create_from_spirv(shader_spirv)
	_pipeline = _rd.compute_pipeline_create(_shader)

func _initialize_compute_code() -> void:

	_load_shader()
	
	# Uniform where results are stored
	_output_uniform = RDUniform.new()
	_output_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	_output_uniform.binding = 0

	var bytes = PackedByteArray()
	bytes.resize(Constants.MAX_COMPUTE_BUFFER_SIZE * 4)
	bytes.fill(0)
	_output_storage_buffer = _rd.storage_buffer_create(
		bytes.size(),
		bytes)
	_output_uniform.add_id(_output_storage_buffer)

	
	# Uniform where weights results are stored
	_weights_uniform = RDUniform.new()
	_weights_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	_weights_uniform.binding = 1

	var weight_bytes = PackedByteArray()
	weight_bytes.resize(Constants.MAX_COMPUTE_BUFFER_SIZE * 4)
	weight_bytes.fill(0)
	_weights_storage_buffer = _rd.storage_buffer_create(
		weight_bytes.size(),
		weight_bytes)
	_weights_uniform.add_id(_weights_storage_buffer)
	
	# Cretates uniform set in set = 0
	_uniform_set_rid = _rd.uniform_set_create([_output_uniform, _weights_uniform], _shader, 0)


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
