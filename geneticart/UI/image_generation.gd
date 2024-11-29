extends Node

signal generation_started
signal generation_finished
signal individual_generated
signal source_texture_updated

@export_category("Scripts")
@export var image_generator_script: GDScript
@export var individual_generator_script: GDScript
@export var individual_renderer_script: GDScript
@export var average_color_sampler_script: GDScript
@export var fitness_calculator_script: GDScript
@export var populator_script: GDScript

var image_generator: ImageGenerator
var individual_generator: IndividualGenerator
var _individual_renderer: IndividualRenderer


func clear_source_texture():
	individual_generator.clear_source_texture()
	source_texture_updated.emit()

func generate() -> void:
	generation_started.emit()
	# Executes the generation in another thread to avoild locking the UI
	WorkerThreadPool.add_task(_begin_image_generation)

func _ready() -> void:
	_setup_references()
	
func _setup_references():
	# Individual generator
	individual_generator = individual_generator_script.new()
	_individual_renderer = individual_renderer_script.new()
	individual_generator.individual_renderer = _individual_renderer
	individual_generator.populator = populator_script.new()
	individual_generator.average_color_sampler = average_color_sampler_script.new()
	individual_generator.fitness_calculator = fitness_calculator_script.new()
	
	# Image generator
	image_generator = image_generator_script.new()
	image_generator.individual_generator = individual_generator
	image_generator.individual_renderer = _individual_renderer
	
	image_generator.initialize(Globals.settings.image_generator_params)
	image_generator.individual_generated.connect(
		func(i): 
			call_deferred("emit_signal", "individual_generated")
			call_deferred("emit_signal", "source_texture_updated"))
	
	clear_source_texture()
	
func _begin_image_generation():
	image_generator.generate_image()
	call_deferred("emit_signal", "generation_finished")
