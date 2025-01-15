class_name GaussianBlurImageProcessor extends ImageProcessor

const LOCAL_SIZE = 32

var kernel_size: int = 5:
	set(value):
		if value > 64:
			push_error("Kernel size can't be grater than 64.")
			return
		
		kernel_size = value
		
var iterations: int = 10
var sigma: float = 2.0

var _texture_a_uniform: RDUniform
var _texture_b_uniform: RDUniform

var _texture_a: RendererTexture
var _texture_b: RendererTexture

var _texture_a_set_rid: RID
var _texture_b_set_rid: RID

var _rd: RenderingDevice

var _shader: RID
var _pipeline: RID

func process_image(texture: RendererTexture) -> RendererTexture:
	
	_refresh_textures(texture)
	
	var output_texture: RendererTexture = null
	for i in range(iterations * 2):
		output_texture = _execute_pass(i)
	
	return output_texture
	
func _execute_pass(i: int) -> RendererTexture:
	
	var direction = Vector2(
		i % 2,
		1.0 - (i % 2))
	
	_texture_a_uniform.clear_ids()
	_texture_b_uniform.clear_ids()

	_texture_a_uniform.add_id(_texture_a.rd_rid if i % 2 == 0 else _texture_b.rd_rid)
	_texture_b_uniform.add_id(_texture_b.rd_rid if i % 2 == 0 else _texture_a.rd_rid)
	
	_texture_a_set_rid = _rd.uniform_set_create([_texture_a_uniform], _shader, 0)
	_texture_b_set_rid = _rd.uniform_set_create([_texture_b_uniform], _shader, 1)

	var texture_width = _texture_a.get_width()
	var texture_height = _texture_a.get_height()
	
	var workgroup_size_x = ceili(float(texture_width) / LOCAL_SIZE)
	var workgroup_size_y = ceili(float(texture_height) / LOCAL_SIZE)
	
	var push_constant := PackedFloat32Array([
		# Vec2 texture size
		texture_width,
		texture_height,
		
		direction.x,
		direction.y,
		
		sigma,
		kernel_size,
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

	return _texture_b if i % 2 == 0 else _texture_a

func _init() -> void:
	_rd = Renderer.rd

	# Create our _shader.
	var shader_file := load("res://shaders/compute/image_processing/gaussian_blur.glsl")
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


func _refresh_textures(texture: RendererTexture):
	_texture_a = texture.copy()
	_texture_b = texture.copy()
