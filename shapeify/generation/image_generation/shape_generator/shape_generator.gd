# An algorithm that, given a set of parameters, a target texture, and a source texture, 
# generates the best possible shape. This shape, when added to the source texture, 
# minimizes the error metric relative to the target texture.
class_name ShapeGenerator extends RefCounted

enum Type{
	Random,
	BestOfRandom,
	Genetic,
	HillClimb
}

var _color_sampler_strategy: ColorSamplerStrategy
var _shape_spawner: ShapeSpawner

var weight_texture: RendererTexture

var params: ShapeGeneratorParams:
	set(value):
		params = value

var generated_count = 0

func setup() -> void:
	generated_count = 0
	if params == null:
		printerr("IndividialGenerator not initialized")
		return

	Profiler.shape_generation_began(params)
	_setup()
	
func finished() -> void:
	_color_sampler_strategy = null
	weight_texture = null

func generate_shape(similarity: float) -> Shape:
	
	if params == null:
		printerr("IndividialGenerator not initialized")
		return
		
	if generated_count % 20 == 0:
		_shape_spawner.update(
			similarity, 
			params.target_texture, 
			params.source_texture,
			weight_texture)
	var shape = _generate(similarity)
	generated_count += 1
	
	Profiler.shape_generation_finished(
		shape,
		params.source_texture)
	return shape

func _setup():
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
		var target_aspect = float(params.target_texture.get_width()) / params.target_texture.get_height()
		var texture_aspect = float(shape.texture.get_height()) / shape.texture.get_width()
		shape.size.y = shape.size.x * target_aspect * texture_aspect
	
	# Can't rotate
	if params.fixed_rotation:
		shape.rotation = params.fixed_rotation_angle
		
	# Clamps position
	if params.clamp_position_in_canvas:
		shape.position.x = clamp(shape.position.x, 0, 1.0)
		shape.position.y = clamp(shape.position.y, 0, 1.0)
	
	if params.fixed_size:
		shape.size.x = params.fixed_size_width_ratio
		var target_aspect = float(params.target_texture.get_width()) / params.target_texture.get_height()
		var texture_aspect = float(shape.texture.get_height()) / shape.texture.get_width()
		shape.size.y = shape.size.x * target_aspect * texture_aspect

	shape.size.x = max(shape.size.x, 0.000001)
	shape.size.y = max(shape.size.y, 0.000001)

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
		_:
			push_error("Unimplemented shape generator of type %s" % type)
			return null
