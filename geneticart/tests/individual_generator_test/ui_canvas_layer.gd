extends CanvasLayer

@export var individual_textures: Array[RendererTexture] = []
@export var target_texture: RendererTexture


@export_category("Scripts")
@export var individual_generator_script: GDScript
@export var individual_renderer_script: GDScript
@export var average_color_sampler_script: GDScript
@export var fitness_calculator_script: GDScript
@export var populator_script: GDScript

@export var output_texture: TextureRect
@export var population_size_input: Control

var _individual_renderer: IndividualRenderer
var _individual_generator: IndividualGenerator

func _ready() -> void:

	var params := IndividualGeneratorParams.new()
	# Populator params
	params.populator_params = PopulatorParams.new()
	params.populator_params.population_size = 10
	params.populator_params.position_bound_min = Vector2.ZERO
	params.populator_params.position_bound_max = target_texture.get_size()
	
	var max_width_height = maxf(
		target_texture.get_width(), 
		target_texture.get_height())
	params.populator_params.size_bound_max = Vector2(max_width_height, max_width_height)
	params.populator_params.textures = individual_textures
	
	# Texture
	params.target_texture = target_texture
	
	_individual_generator = individual_generator_script.new()
	
	_individual_renderer = individual_renderer_script.new()
	_individual_generator.individual_renderer = _individual_renderer
	_individual_generator.populator = populator_script.new()
	_individual_generator.average_color_sampler = average_color_sampler_script.new()
	_individual_generator.fitness_calculator = fitness_calculator_script.new()
	_individual_generator.initialize(params)


func setup_params():
	_individual_generator.params.populator_params.population_size = population_size_input.get_number()
	
# Called when the node enters the scene tree for the first time.
func generate() -> void:
	var clock = Clock.new()
	setup_params()
	output_texture.visible = false
	var individual = await _individual_generator.generate_individual()
	clock.print_elapsed("Generated individual with fitness: %s" % individual.fitness)
	
	output_texture.visible = true
	_individual_renderer.render_individual(individual)
	
	## Stores the output texture
	#var img: Image = output_texture.texture.get_image()
	#img.save_png("res://art/output/out.png")
	

func _on_button_pressed() -> void:
	generate()
