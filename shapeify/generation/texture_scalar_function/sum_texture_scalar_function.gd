extends TextureScalarFunction

# Everything after this point is designed to run on our rendering thread.
var _rd: RenderingDevice
var _shader: RID
var _pipeline: RID

# Uniform that holds the result
var _output_uniform: RDUniform
var _output_storage_buffer: RID

var _uniform_set_rid: RID

var _sample_texture_set_rid: RID


var _last_sample_texture_rid: RID

func _set_sample_texture(texture: RendererTexture):
	
	# Already set
	if texture.rd_rid == _last_sample_texture_rid:
		return
	
	if _sample_texture_set_rid.is_valid():
		_rd.free_rid(_sample_texture_set_rid)

	# Creates the texture uniform
	var image_uniform := RDUniform.new()
	image_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	image_uniform.binding = 0
	image_uniform.add_id(texture.rd_rid)
	
	# Creates texture set
	_sample_texture_set_rid = _rd.uniform_set_create([image_uniform], _shader, 1)
	_last_sample_texture_rid = texture.rd_rid

func evaluate(texture: RendererTexture) -> float:
	
	_set_sample_texture(texture)
	
	var texture_width =  texture.get_width()
	var texture_height = texture.get_height()
	var pixel_count = texture_width * texture_height
	
	var local_size_x = 256
	var workgroup_size_x = ceili(float(pixel_count) / local_size_x)
	
	var push_constant := PackedFloat32Array([
		# Vec2 texture size
		texture_width, texture_height,
		
		# Pixel count
		texture_width * texture_height,
		0.0
	])
	
	var push_constant_byte_array = push_constant.to_byte_array()
	# Run our compute _shader.
	var compute_list := _rd.compute_list_begin()
	_rd.compute_list_bind_compute_pipeline(compute_list, _pipeline)
	_rd.compute_list_bind_uniform_set(compute_list, _uniform_set_rid, 0)
	_rd.compute_list_bind_uniform_set(compute_list, _sample_texture_set_rid, 1)
	_rd.compute_list_set_push_constant(compute_list, push_constant_byte_array, push_constant_byte_array.size())
	_rd.compute_list_dispatch(
		compute_list, 
		workgroup_size_x, 
		1, 
		1)
	_rd.compute_list_end()
	
	# Gets compute output. Note that buffer_get_data causes stall
	var output_bytes = _rd.buffer_get_data(_output_storage_buffer, 0, workgroup_size_x * 4)
	var components = output_bytes.to_float32_array()
	var sum: float = 0.0
	for i in range(workgroup_size_x):
		sum += components[i]
	return sum
	

func _init() -> void:
	_initialize_compute_code()

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		_rd.free_rid(_output_storage_buffer)
		_rd.free_rid(_sample_texture_set_rid)
		_rd.free_rid(_pipeline)
		_rd.free_rid(_shader)


func _load_shader():
	_rd = Renderer.rd

	# Create our _shader.
	var shader_file := load("res://shaders/compute/texture_scalar_function/sum_texture_scalar_function.glsl")
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
	
	# Cretates uniform set in set = 0
	_uniform_set_rid = _rd.uniform_set_create([_output_uniform], _shader, 0)
