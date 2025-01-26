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
var _shape_renderer: ShapeRenderer
var _populator: Populator

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

func generate_shape() -> Shape:
	
	if params == null:
		printerr("IndividialGenerator not initialized")
		return
	
	Profiler.shape_generation_began(params)
	_setup()
	var shape = _generate()
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


var _current_sampler_strategy : ColorSamplerStrategy.Type

func _setup():
	
	if source_texture == null:
		clear_source_texture()
	
	_shape_renderer.source_texture = source_texture

	# Setup populator params ---------------------------------------------------
	params.populator_params.position_bound_min = Vector2.ZERO
	params.populator_params.position_bound_max = source_texture.get_size()
	var max_width_height = maxf(source_texture.get_width(), source_texture.get_height())
	params.populator_params.size_bound_max = Vector2(max_width_height, max_width_height)
	
	# Setup color sampler strategy ---------------------------------------------
	if _current_sampler_strategy != params.color_sampler or _color_sampler_strategy == null:
		_color_sampler_strategy = ColorSamplerStrategy.factory_create(params.color_sampler)
		_current_sampler_strategy = params.color_sampler
	
	_color_sampler_strategy.sample_texture = params.target_texture
	
	
func _generate() -> Shape:
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

func _init() -> void:
	_shape_renderer = ShapeRenderer.new()
	# Setup populator ----------------------------------------------------------
	_populator = load("res://generation/image_generation/shape_generator/common/random_populator.gd").new()


static func factory_create(type: Type):
	# Setup individual generator -----------------------------------------------
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
			push_error("Unimplemented individual generator of type %s" % type)
			return null
