extends MaskedAverageColorSampler


# Everything after this point is designed to run on our rendering thread.
var _rd: RenderingDevice
var _shader: RID
var _pipeline: RID

# Uniform that holds the result
var _output_uniform: RDUniform

var _sample_texture_set_rid: RID
var _id_texture_set_rid: RID

# Array where the calculations results are stored
var _result_bytes := PackedByteArray()


func sample_rect(rect: Rect2i) -> Color:
		
	if not sample_texture.is_valid():
		printerr("Trying to sample_rect() from invalid sample_texture on AverageColorSampler")
		return Color.HOT_PINK
	
	var sample_width = rect.size.x
	var sample_height = rect.size.y
	
	var group_size_x = sample_width
	var group_size_y = sample_height
	var local_size = 8
	
	# Creates the buffer, that will hold the actual data that the CPU will send to the GPU
	var result_float_array = PackedFloat32Array()
	result_float_array.append_array(
		[
			0, # COLOR.r
			0, # COLOR.g
			0, # COLOR.b
			0, # COLOR.a
			0  # Samples count
		]
	)
	_result_bytes = result_float_array.to_byte_array()
	
	# Ensures synchronization, since the execute_compute function also uses
	var storage_buffer_result_rid = _rd.storage_buffer_create(
		_result_bytes.size(),
		_result_bytes)
		
	_output_uniform.add_id(storage_buffer_result_rid)
	
	var uniform_set_rid = _rd.uniform_set_create([_output_uniform], _shader, 0)
	
	var push_constant := PackedFloat32Array([
		# Vec2 texture size
		sample_texture.get_width(),
		sample_texture.get_height(),
		
		# Vec2 offset
		rect.position.x,
		rect.position.y
	])
	
	var push_constant_byte_array = push_constant.to_byte_array()
	# Run our compute _shader.
	var compute_list := _rd.compute_list_begin()
	_rd.compute_list_bind_compute_pipeline(compute_list, _pipeline)
	_rd.compute_list_bind_uniform_set(compute_list, uniform_set_rid, 0)
	_rd.compute_list_bind_uniform_set(compute_list, _sample_texture_set_rid, 1)
	_rd.compute_list_bind_uniform_set(compute_list, _id_texture_set_rid, 2)
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
	var accumulated_color = Color(
		output[0],
		output[1],
		output[2],
		output[3])
		
	var sample_count = output[4]
	
	# Frees resouces
	_rd.free_rid(storage_buffer_result_rid)

	_output_uniform.clear_ids()
	var avg_color = accumulated_color / sample_count
	return avg_color

func _init() -> void:
	RenderingServer.call_on_render_thread(_initialize_compute_code)

func _exit_tree() -> void:
	_rd.free_rid(_shader)
	
func _load_shader():
	_rd = Renderer.rd

	# Create our _shader.
	var shader_file := load("res://shaders/compute/masked_avg_color_subrect_sampler.glsl")
	var shader_spirv: RDShaderSPIRV = shader_file.get_spirv()
	_shader = _rd.shader_create_from_spirv(shader_spirv)
	_pipeline = _rd.compute_pipeline_create(_shader)

func _initialize_compute_code() -> void:

	_load_shader()
	
	# Uniform where results are stored
	_output_uniform = RDUniform.new()
	_output_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	_output_uniform.binding = 0


func _sample_texture_set():
	
	if _sample_texture_set_rid.is_valid():
		_rd.free_rid(_sample_texture_set_rid)
	
	# Creates the texture uniform
	var image_uniform := RDUniform.new()
	image_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	image_uniform.binding = 0
	image_uniform.add_id(sample_texture.rd_rid)
	
	# Creates texture set
	_sample_texture_set_rid = _rd.uniform_set_create([image_uniform], _shader, 1)

func _id_texture_set():
	
	if _id_texture_set_rid.is_valid():
		_rd.free_rid(_id_texture_set_rid)
	
	# Creates the texture uniform
	var image_uniform := RDUniform.new()
	image_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	image_uniform.binding = 0
	image_uniform.add_id(id_texture.rd_rid)
	
	# Creates texture set
	_id_texture_set_rid = _rd.uniform_set_create([image_uniform], _shader, 2)
