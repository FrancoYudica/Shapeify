extends Node

signal generation_started
signal generation_finished
signal individual_generated(individual: Individual)
signal source_texture_updated
signal target_texture_updated

@export_category("Scripts")
@export var image_generator_script: GDScript

@export_group("Individual generators")
@export var random_individual_generator_script: GDScript
@export var genetic_individual_generator_script: GDScript

@export_group("Components")
@export var individual_renderer_script: GDScript
@export var average_color_sampler_script: GDScript
@export var fitness_calculator_script: GDScript
@export var populator_script: GDScript

@export_group("Metric")
@export var metric_scripts: Array[GDScript]

var image_generator: ImageGenerator
var individual_generator: IndividualGenerator
var _individual_renderer: IndividualRenderer
var metrics: Array[Metric]

func clear_source_texture():
	individual_generator.clear_source_texture()
	source_texture_updated.emit()

func generate() -> void:
	generation_started.emit()
	# Executes the generation in another thread to avoild locking the UI
	WorkerThreadPool.add_task(_begin_image_generation)

func stop():
	image_generator.stop()

func refresh_target_texture():
	image_generator.update_target_texture(
		Globals \
		.settings \
		.image_generator_params \
		.individual_generator_params \
		.target_texture)
	
	target_texture_updated.emit()
	clear_source_texture()

func set_individual_generator_type(type: ImageGeneratorParams.IndividualGeneratorType):
	match type:
		ImageGeneratorParams.IndividualGeneratorType.Random:
			_set_individual_generator_script(load("res://generation/individual_generator/random/random_individual_generator.gd"))
		ImageGeneratorParams.IndividualGeneratorType.BestOfRandom:
			_set_individual_generator_script(random_individual_generator_script)
		ImageGeneratorParams.IndividualGeneratorType.Genetic:
			_set_individual_generator_script(genetic_individual_generator_script)
		_:
			push_error("Unimplemented individual generator of type: %s" % type)

func _set_individual_generator_script(script: GDScript):
	individual_generator = script.new() as IndividualGenerator
	if individual_generator == null:
		push_error("Trying to assign invalid script as a generator")
		return

	individual_generator.individual_renderer = _individual_renderer
	individual_generator.populator = populator_script.new()
	individual_generator.average_color_sampler = average_color_sampler_script.new()
	individual_generator.fitness_calculator = fitness_calculator_script.new()
	image_generator.individual_generator = individual_generator
	individual_generator.params = Globals.settings.image_generator_params.individual_generator_params
	

func _ready() -> void:
	_setup_references()
	target_texture_updated.emit()
	
	for metric_script in metric_scripts:
		var metric = metric_script.new() as Metric
		if metric == null:
			push_error("Trying to create a metric with invalid script: %s" % metric_script.resource_path)
			continue
			
		metrics.append(metric)
	
	
func _setup_references():
	# Individual generator
	_individual_renderer = individual_renderer_script.new()

	# Image generator
	image_generator = image_generator_script.new()
	image_generator.individual_renderer = _individual_renderer
	image_generator.params = Globals.settings.image_generator_params
	image_generator.individual_generated.connect(
		func(i): 
			call_deferred("_emit_individual_generated_signal", i)
			call_deferred("emit_signal", "source_texture_updated"))
	
	set_individual_generator_type(Globals.settings.image_generator_params.individual_generator_type)
	
	clear_source_texture()

func _emit_individual_generated_signal(individual: Individual):
	individual_generated.emit(individual)

func _begin_image_generation():
	image_generator.generate_image()
	call_deferred("emit_signal", "generation_finished")
