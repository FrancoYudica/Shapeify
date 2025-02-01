# An algorithm that, given a set of parameters, a target texture, and a source texture, 
# generates the best possible shape. This shape, when added to the source texture, 
# minimizes the error metric relative to the target texture.
class_name ShapeGenerator extends RefCounted

enum Type{
	Random,
	BestOfRandom,
	Genetic,
	HillClimb,
	ShaderDriven
}

var _color_sampler_strategy: ColorSamplerStrategy
var _shape_spawner: ShapeSpawner

var source_texture: RendererTexture
var weight_texture: RendererTexture

var params: ShapeGeneratorParams:
	set(value):
		params = value
		update_target_texture(params.target_texture)

func update_target_texture(target_texture: RendererTexture):
	if not target_texture.is_valid():
		printerr("Trying to initialize ShapeGenerator but target_texture is invalid")
		return
		
	clear_source_texture()

var generated_count = 0

func setup() -> void:
	generated_count = 0
	if params == null:
		printerr("IndividialGenerator not initialized")
		return

	Profiler.shape_generation_began(params)

	var clock := Clock.new()
	_setup()
	print("Setup: %s" % clock.elapsed_ms())
	
func finished() -> void:
	_color_sampler_strategy = null
	source_texture = null
	weight_texture = null

func generate_shape(similarity: float) -> Shape:
	
	if params == null:
		printerr("IndividialGenerator not initialized")
		return
	
	if generated_count % 10 == 0:
		generated_count += 1
		_shape_spawner.update(0, params.target_texture, source_texture)

	var shape = _generate(similarity)
	Profiler.shape_generation_finished(
		shape,
		source_texture)
	return shape

func clear_source_texture():
	
	var image_color = ImageUtils.get_texture_average_color(params.target_texture)
	
	var img = ImageUtils.create_monochromatic_image(
		params.target_texture.get_width(),
		params.target_texture.get_height(),
		image_color)
	
	# Creates to image texture and then to RD local texture
	var source_texture_global_rd = ImageTexture.create_from_image(img)
	source_texture = RendererTexture.load_from_texture(source_texture_global_rd)

func _setup():
	
	if source_texture == null:
		clear_source_texture()

	_shape_spawner = ShapeSpawner.new()
	_shape_spawner.set_params(params.shape_spawner_params)
	
	# Setup color sampler strategy ---------------------------------------------
	_color_sampler_strategy = ColorSamplerStrategy.factory_create(params.color_sampler)
	_color_sampler_strategy.sample_texture = params.target_texture
	
func _generate(similarity: float) -> Shape:
	return

## Applies settings and ensures that all the properties have valid values
func _fix_shape_attributes(shape: Shape):
	
	# If the aspect ratio
	if params.keep_aspect_ratio:
		var aspect = float(shape.texture.get_height()) / shape.texture.get_width()
		shape.size.y = shape.size.x * aspect
	
	# Can't rotate
	if params.fixed_rotation:
		shape.rotation = params.fixed_rotation_angle
		
	# Clamps position
	if params.clamp_position_in_canvas:
		shape.position.x = clampi(shape.position.x, 0, params.target_texture.get_width())
		shape.position.y = clampi(shape.position.y, 0, params.target_texture.get_height())
	
	if params.fixed_size:
		shape.size.x = source_texture.get_width() * params.fixed_size_width_ratio
		var aspect = float(shape.texture.get_height()) / shape.texture.get_width()
		shape.size.y = shape.size.x * aspect

	shape.size.x = max(shape.size.x, 1.0)
	shape.size.y = max(shape.size.y, 1.0)

static func factory_create(type: Type):
	# Setup shape generator -----------------------------------------------
	match type:
		Type.Random:
			return load("res://generation/image_generation/shape_generator/random/random_shape_generator.gd").new()
		Type.BestOfRandom:
			return load("res://generation/image_generation/shape_generator/best_of_random/best_of_random_shape_generator.gd").new()
		Type.Genetic:
			return load("res://generation/image_generation/shape_generator/genetic/genetic_shape_generator.gd").new()
		Type.HillClimb:
			return load("res://generation/image_generation/shape_generator/hill_climbing/hill_climbing_shape_generator.gd").new()
		Type.ShaderDriven:
			return load("res://generation/image_generation/shape_generator/shader_driven/shader_driven_shape_generator.gd").new()
		_:
			push_error("Unimplemented shape generator of type %s" % type)
			return null
