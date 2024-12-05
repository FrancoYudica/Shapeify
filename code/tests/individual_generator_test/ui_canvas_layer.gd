extends CanvasLayer

@export var individual_generator_script: GDScript
@export var individual_generator_parms: IndividualGeneratorParams

@export var output_texture: TextureRect
@export var population_size_input: Control

var _individual_generator: IndividualGenerator

func _ready() -> void:
	_individual_generator = individual_generator_script.new()
	_individual_generator.params = individual_generator_parms
	
func generate() -> void:
	_individual_generator.params.best_of_random_params.individual_count = population_size_input.get_number()
	output_texture.visible = false
	
	var clock = Clock.new()
	var individual = _individual_generator.generate_individual()
	clock.print_elapsed("Generated individual with fitness: %s" % individual.fitness)
	output_texture.visible = true

func _on_button_pressed() -> void:
	generate()
