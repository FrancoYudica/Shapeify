extends AverageColorSampler


# Everything after this point is designed to run on our rendering thread.
var _rd: RenderingDevice
var _shader: RID
var _pipeline: RID

# Uniform that holds the result
var _output_uniform: RDUniform
var _samples_output_uniform: RDUniform

var _sample_texture_set_rid: RID
var _id_texture_set_rid: RID



func sample_rect(rect: Rect2i) -> Color:
		
	if not sample_texture.is_valid():
		printerr("Trying to sample_rect() from invalid sample_texture on AverageColorSampler")
		return Color.HOT_PINK
	
	var sample_width = rect.size.x
	var sample_height = rect.size.y
	var pixel_count = sample_width * sample_height
	
	var local_size_x = 256
	var workgroup_size_x = ceili(float(pixel_count) / local_size_x)
	
	# Creates a storage buffer that holds the partial colors sum -----------------------------------
	var color_sum_array = PackedFloat32Array()
	color_sum_array.resize(workgroup_size_x * 4)
	color_sum_array.fill(0.0)
	var color_sum_bytes = color_sum_array.to_byte_array()
	var color_sum_storage_buffer = _rd.storage_buffer_create(
		color_sum_bytes.size(),
		color_sum_bytes)
		
	# Creates a storage buffer that holds the partial samples count sum ----------------------------
	var samples_count_array = PackedFloat32Array()
	samples_count_array.resize(workgroup_size_x)
	samples_count_array.fill(0.0)
	var samples_count_bytes = samples_count_array.to_byte_array()
	var samples_count_storage_buffer = _rd.storage_buffer_create(
		samples_count_bytes.size(),
		samples_count_bytes)
		
	_output_uniform.add_id(color_sum_storage_buffer)
	_samples_output_uniform.add_id(samples_count_storage_buffer)
	
	var uniform_set_rid = _rd.uniform_set_create(
		[_output_uniform, _samples_output_uniform], 
		_shader, 
		0)
	
	var push_constant := PackedFloat32Array([
		# Vec2 texture size
		sample_texture.get_width(),
		sample_texture.get_height(),

		# Sample size
		rect.size.x,
		rect.size.y,
		
		# Sample offset
		rect.position.x,
		rect.position.y,
		
		0.0,
		0.0
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
		workgroup_size_x, 
		1, 
		1)
	_rd.compute_list_end()
	_rd.submit()
	_rd.sync()
	
	# Gets compute output. Note that buffer_get_data causes stall
	var partial_colors_sum_output_bytes = _rd.buffer_get_data(color_sum_storage_buffer)
	var partial_colors_sum_output = partial_colors_sum_output_bytes.to_float32_array()

	var partial_samples_sum_output_bytes = _rd.buffer_get_data(samples_count_storage_buffer)
	var partial_samples_sum = partial_samples_sum_output_bytes.to_float32_array()
	
	var sample_count = 0
	for n in partial_samples_sum:
		sample_count += n
		
	# Adds up all the results
	var accumulated_colors: Color
	for i in range(partial_colors_sum_output.size() / 4):
		var index = i * 4
		accumulated_colors.r += partial_colors_sum_output[index]
		accumulated_colors.g += partial_colors_sum_output[index + 1]
		accumulated_colors.b += partial_colors_sum_output[index + 2]
		accumulated_colors.a += partial_colors_sum_output[index + 3]
	
	# Frees resouces
	_rd.free_rid(color_sum_storage_buffer)
	_rd.free_rid(samples_count_storage_buffer)

	_output_uniform.clear_ids()
	_samples_output_uniform.clear_ids()
	
	if _rd.uniform_set_is_valid(uniform_set_rid):
		_rd.free_rid(uniform_set_rid)

	return accumulated_colors / sample_count

func _init() -> void:
	_initialize_compute_code()

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		_rd.free_rid(_sample_texture_set_rid)
		_rd.free_rid(_pipeline)
		_rd.free_rid(_shader)
		
	
func _load_shader():
	_rd = Renderer.rd

	# Create our _shader.
	var shader_file := load("res://shaders/compute/masked_avg_color_subrect_sampler_reduction.glsl")
	var shader_spirv: RDShaderSPIRV = shader_file.get_spirv()
	_shader = _rd.shader_create_from_spirv(shader_spirv)
	_pipeline = _rd.compute_pipeline_create(_shader)

func _initialize_compute_code() -> void:

	_load_shader()
	
	# Uniform where results are stored
	_output_uniform = RDUniform.new()
	_output_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	_output_uniform.binding = 0
	
	_samples_output_uniform = RDUniform.new()
	_samples_output_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	_samples_output_uniform.binding = 1


func _sample_texture_set():
	
	if _sample_texture_set_rid.is_valid() and _rd.uniform_set_is_valid(_sample_texture_set_rid):
		_rd.free_rid(_sample_texture_set_rid)
	
	# Creates the texture uniform
	var image_uniform := RDUniform.new()
	image_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	image_uniform.binding = 0
	image_uniform.add_id(sample_texture.rd_rid)
	
	# Creates texture set
	_sample_texture_set_rid = _rd.uniform_set_create([image_uniform], _shader, 1)

func _id_texture_set():
	
	if _id_texture_set_rid.is_valid() and _rd.uniform_set_is_valid(_id_texture_set_rid):
		_rd.free_rid(_id_texture_set_rid)
	
	# Creates the texture uniform
	var image_uniform := RDUniform.new()
	image_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	image_uniform.binding = 0
	image_uniform.add_id(id_texture.rd_rid)
	
	# Creates texture set
	_id_texture_set_rid = _rd.uniform_set_create([image_uniform], _shader, 2)
