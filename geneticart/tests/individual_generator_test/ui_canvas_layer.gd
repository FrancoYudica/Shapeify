extends CanvasLayer

@export var params: IndividualGeneratorParams

@export var individual_generator: IndividualGenerator
@export var individual_renderer: Node

@export var output_texture: TextureRect

@export var population_size_input: Control

func _ready() -> void:
	individual_generator.initialize()

func setup_params():
	params.populator_params.population_size = population_size_input.get_number()
	params.populator_params.position_bound_min = Vector2.ZERO
	params.populator_params.position_bound_max = individual_generator.target_texture.get_size()
	
	var max_width_height = maxf(
		individual_generator.target_texture.get_width(), 
		individual_generator.target_texture.get_width())
	params.populator_params.size_bound_max = Vector2(max_width_height, max_width_height)
	

# Called when the node enters the scene tree for the first time.
func generate() -> void:
	var clock = Clock.new()
	setup_params()
	output_texture.texture = individual_renderer.get_subviewport_texture()
	
	var individual = await individual_generator.generate_individual(params)
	clock.print_elapsed("Generated individual with fitness: %s" % individual.fitness)
	individual_renderer.push_individual(individual)
	individual_renderer.rendered.connect(
		func (individual, texture):
			output_texture.texture = texture
	)
	individual_renderer.begin_rendering()
	await individual_renderer.finished_rendering
	var img: Image = output_texture.texture.get_image()
	img.save_png("res://art/output/out.png")
	

func _on_button_pressed() -> void:
	generate()
