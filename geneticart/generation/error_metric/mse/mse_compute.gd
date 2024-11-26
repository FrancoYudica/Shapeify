extends ErrorMetric

# Everything after this point is designed to run on our rendering thread.
var _rd: RenderingDevice
var _shader: RID
var _pipeline: RID

# Uniform that holds the result
var _output_uniform: RDUniform

## Textures and texture sets
var _target_texture_set_rid: RID
var _source_texture_set_rid: RID
var _target_texture_rid: RID
var _source_texture_rid: RID

# Array where the calculations results are stored
var _result_bytes := PackedByteArray()


func _compute_rd(source_texture_rd_id) -> float:
	
	if _source_texture_rid != source_texture_rd_id:
		_rd.free_rid(_source_texture_set_rid)
		_source_texture_rid = source_texture_rd_id
		_source_texture_set_rid = _create_texture_uniform_set(_source_texture_rid, 2)
	
	var texture_width = target_texture.get_width()
	var texture_height = target_texture.get_height()
	
	var group_size_x = texture_width
	var group_size_y = texture_height
	var local_size = 8
	
	# Creates the buffer, that will hold the actual data that the CPU will send to the GPU
	var result_float_array = PackedFloat32Array()
	result_float_array.append(0.0)
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
		ceili(float(group_size_x) / local_size), 
		ceili(float(group_size_y) / local_size), 
		1)
	_rd.compute_list_end()
	
	# Gets compute output. Note that buffer_get_data causes stall
	var output_bytes = _rd.buffer_get_data(storage_buffer_result_rid)
	var output = output_bytes.to_float32_array()
	var mse_sum = output[0]
	var mse = 1.0 / ((texture_width * texture_height) * 3) * mse_sum
	
	# Frees resouces
	_rd.free_rid(storage_buffer_result_rid)

	_output_uniform.clear_ids()
	
	return mse
	
func _compute(source_texture: Texture2D) -> float:
	
	# Updates texture contents
	RenderingCommon.update_texture_diff_rd(
		RenderingServer.texture_get_rd_texture(source_texture.get_rid()),
		_source_texture_rid,
		RenderingServer.get_rendering_device(),
		_rd
	)
	return _compute_rd(_source_texture_rid)

func _ready() -> void:
	RenderingServer.call_on_render_thread(_initialize_compute_code)

func _set_target_texture(texture):
	if _target_texture_set_rid.is_valid():
		_rd.free_rid(_target_texture_set_rid)
	
	if _target_texture_rid.is_valid():
		_rd.free_rid(_target_texture_rid)
	
	# Creates the uniform that contains the target texture
	var target_texture_format = RenderingCommon.copy_texture_format(
		RenderingServer.get_rendering_device(),
		RenderingServer.texture_get_rd_texture(texture.get_rid())
	)
	_target_texture_rid = _create_texture_from_format(target_texture_format)
	RenderingCommon.update_texture_diff_rd(
		RenderingServer.texture_get_rd_texture(texture.get_rid()),
		_target_texture_rid,
		RenderingServer.get_rendering_device(),
		_rd
	)
	
	_target_texture_set_rid = _create_texture_uniform_set(_target_texture_rid, 1)
	
	
	# Does the same but for source texture
	if _source_texture_set_rid.is_valid():
		_rd.free_rid(_source_texture_set_rid)
	
	if _source_texture_rid.is_valid():
		_rd.free_rid(_source_texture_rid)
	
	# Creates the uniform that contains the target texture
	_source_texture_rid = _create_texture_from_format(target_texture_format)
	_source_texture_set_rid = _create_texture_uniform_set(_source_texture_rid, 2)



func _exit_tree() -> void:
	_rd.free_rid(_shader)
	
	if _target_texture_rid.is_valid():
		_rd.free_rid(_target_texture_rid)
		
	if _source_texture_rid.is_valid():
		_rd.free_rid(_source_texture_rid)

func _load_shader():
	# As this becomes part of our normal frame rendering,
	# we use our main rendering device here.
	#_rd = RenderingServer.get_rendering_device()
	_rd = Renderer.rd

	# Create our _shader.
	var shader_file := load("res://shaders/image_mse.glsl")
	var shader_spirv: RDShaderSPIRV = shader_file.get_spirv()
	_shader = _rd.shader_create_from_spirv(shader_spirv)
	_pipeline = _rd.compute_pipeline_create(_shader)

func _initialize_compute_code() -> void:

	_load_shader()
	
	# Uniform where results are stored
	_output_uniform = RDUniform.new()
	_output_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	_output_uniform.binding = 0
	

## Creates a rendering device texture with the same format as `src_texture`
func _create_texture_from_format(texture_format: RDTextureFormat) -> RID:
	texture_format.usage_bits |= (
			RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT |
			RenderingDevice.TEXTURE_USAGE_STORAGE_BIT  |
			RenderingDevice.TEXTURE_USAGE_CAN_COPY_TO_BIT )
	
	# Creates target texture and copies
	var copy_texture_rid = _rd.texture_create(texture_format, RDTextureView.new(), [])
	return copy_texture_rid

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
