extends AverageColorSampler


# Everything after this point is designed to run on our rendering thread.
var _rd: RenderingDevice
var _shader: RID
var _pipeline: RID

# Uniform that holds the result
var _output_uniform: RDUniform

## Textures and texture sets
var _sample_texture_set_rid: RID
var _sample_texture_rid: RID

# Array where the calculations results are stored
var _result_bytes := PackedByteArray()

func _set_sample_texture(texture):
	
	if _sample_texture_set_rid.is_valid():
		_rd.free_rid(_sample_texture_set_rid)
	
	if _sample_texture_rid.is_valid():
		_rd.free_rid(_sample_texture_rid)
	
	# Creates the uniform that contains the sample texture
	_sample_texture_rid = _create_rd_texture_copy(texture)

	# Creates the texture uniform
	var image_uniform := RDUniform.new()
	image_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	image_uniform.binding = 0
	image_uniform.add_id(_sample_texture_rid)
	
	# Creates texture set
	_sample_texture_set_rid = _rd.uniform_set_create([image_uniform], _shader, 1)
	

func _ready() -> void:
	RenderingServer.call_on_render_thread(_initialize_compute_code)

func _exit_tree() -> void:
	_rd.free_rid(_shader)
	
	if _sample_texture_rid.is_valid():
		_rd.free_rid(_sample_texture_rid)

func _load_shader():
	# As this becomes part of our normal frame rendering,
	# we use our main rendering device here.
	_rd = RenderingServer.get_rendering_device()

	# Create our _shader.
	var shader_file := load("res://shaders/average_color_subrect_sampler.glsl")
	var shader_spirv: RDShaderSPIRV = shader_file.get_spirv()
	_shader = _rd.shader_create_from_spirv(shader_spirv)
	_pipeline = _rd.compute_pipeline_create(_shader)

func _initialize_compute_code() -> void:

	_load_shader()
	
	# Uniform where results are stored
	_output_uniform = RDUniform.new()
	_output_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	_output_uniform.binding = 0


## Creates a rendering device texture and copies the contents and format of src texture
func _create_rd_texture_copy(src_texture: Texture) -> RID:
	# Gets texture RenderingServer ID
	var texture_rdid = RenderingServer.texture_get_rd_texture(src_texture.get_rid())
	# Gets the original texture format but changes the usage bits
	var original_texture_format = _rd.texture_get_format(texture_rdid)
	var texture_format: RDTextureFormat = RDTextureFormat.new()
	texture_format.format = original_texture_format.format
	texture_format.texture_type = original_texture_format.texture_type
	texture_format.width = original_texture_format.width
	texture_format.height = original_texture_format.height
	texture_format.depth = original_texture_format.depth
	texture_format.array_layers = original_texture_format.array_layers
	texture_format.mipmaps = original_texture_format.mipmaps
	texture_format.usage_bits = (
			RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT |
			RenderingDevice.TEXTURE_USAGE_STORAGE_BIT  |
			RenderingDevice.TEXTURE_USAGE_CAN_COPY_TO_BIT )
	
	# Creates target texture and copies
	var copy_texture_rid = _rd.texture_create(texture_format, RDTextureView.new(), [])
	var err = _rd.texture_copy(
		texture_rdid, 
		copy_texture_rid,
		Vector3.ZERO, 
		Vector3.ZERO, 
		Vector3(texture_format.width, texture_format.height, 0),
		0, 0, 0, 0)
	
	if err != OK:
		printerr("Error while copying textures: %s" % err)
	
	return copy_texture_rid


func sample_rect(rect: Rect2i) -> Color:
		
	if sample_texture == null:
		printerr("Sampler texture not set")
		return Color.BLACK
	
	var sample_width = rect.size.x
	var sample_height = rect.size.y
	
	var group_size_x = sample_width
	var group_size_y = sample_height
	var local_size = 4
	
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
	_rd.compute_list_set_push_constant(compute_list, push_constant_byte_array, push_constant_byte_array.size())
	_rd.compute_list_dispatch(
		compute_list, 
		group_size_x / local_size, 
		group_size_y / local_size, 
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
