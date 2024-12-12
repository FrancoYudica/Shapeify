class_name ImageGenerator extends RefCounted

signal individual_generated(individual: Individual)

var params: ImageGeneratorParams

var individual_generator: IndividualGenerator

var _mutex: Mutex = Mutex.new()
var _stop: bool = false
var _stop_condition: StopCondition
var _individual_renderer: IndividualRenderer

func update_target_texture(target_texture: RendererTexture):
	individual_generator.update_target_texture(target_texture)

func stop():
	_mutex.lock()
	_stop = true
	_mutex.unlock()

func get_progress() -> float:
	if _stop_condition == null:
		return 0.0
	return _stop_condition.get_progress()

func generate_image(first_src_texture: RendererTexture) -> RendererTexture:
	
	Profiler.image_generation_began(params)
	
	setup()
	
	# In case the image generator starts with some progress
	if first_src_texture != null:
		individual_generator.source_texture = first_src_texture
		
	var source_texture = individual_generator.source_texture
	_individual_renderer.source_texture = source_texture
	
	_stop_condition.began_generating()
	while not _stop_condition.should_stop():
		
		# Checks if the algorithm should stop executing
		_mutex.lock()
		if _stop:
			_mutex.unlock()
			break
		_mutex.unlock()
		
		# Generates individual
		var individual: Individual = individual_generator.generate_individual()
		
		# Renders the individual onto the source texture
		_individual_renderer.render_individual(individual)
		source_texture.copy_contents(_individual_renderer.get_color_attachment_texture())
		individual_generated.emit(individual)
		_stop_condition.individual_generated(individual)
	
	Profiler.image_generation_finished(individual_generator.source_texture)
	
	return individual_generator.source_texture

var _current_individual_generator_type: int = -1

func setup():
	_stop = false
	
	# Setup stop condition strategy --------------------------------------------
	match params.stop_condition:
		StopCondition.Type.INDIVIDUAL_COUNT:
			_stop_condition = load("res://generation/image_generation/stop_condition/individual_count_stop_condition.gd").new()
		StopCondition.Type.EXECUTION_TIME:
			_stop_condition = load("res://generation/image_generation/stop_condition/execution_time_stop_condition.gd").new()
		StopCondition.Type.TARGET_FITNESS:
			_stop_condition = load("res://generation/image_generation/stop_condition/target_fitness_stop_condition.gd").new()

		_:
			push_error("Unimplemented stop condition of type %s" % params.stop_condition)
	
	_stop_condition.set_params(params.stop_condition_params)
	
	# Setup individual generator -----------------------------------------------
	if _current_individual_generator_type != params.individual_generator_type:
		match params.individual_generator_type:
			IndividualGenerator.Type.Random:
				individual_generator = load("res://generation/individual_generator/random/random_individual_generator.gd").new()
			IndividualGenerator.Type.BestOfRandom:
				individual_generator = load("res://generation/individual_generator/best_of_random/best_of_random_individual_generator.gd").new()
			IndividualGenerator.Type.Genetic:
				individual_generator = load("res://generation/individual_generator/genetic/genetic_individual_generator.gd").new()

			_:
				push_error("Unimplemented individual generator of type %s" % params.individual_generator_type)

		_current_individual_generator_type = params.individual_generator_type
		individual_generator.params = params.individual_generator_params

func _init() -> void:
	_individual_renderer = load("res://generation/individual/individual_renderer.gd").new()
