class_name ImageGenerator extends RefCounted

signal individual_generated(individual: Individual)

var params: ImageGeneratorParams

var individual_generator: IndividualGenerator
var individual_renderer: IndividualRenderer

var _mutex: Mutex = Mutex.new()
var _stop: bool = false
var _stop_condition: StopCondition

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

func generate_image() -> RendererTexture:
	_setup()
	var source_texture = individual_generator.source_texture
	
	_stop_condition.began_generating()
	
	while not _stop_condition.should_stop():
		
		# Checks if the algorithm should stop executing
		_mutex.lock()
		if _stop:
			_mutex.unlock()
			break
		_mutex.unlock()
		
		var individual: Individual = individual_generator.generate_individual()
		
		#individual_renderer.render_individual(individual)
		#var individual_texture = individual_renderer.get_color_attachment_texture().copy()
		#individual_generator.source_texture = individual_texture
		#individual_generated.emit(individual)
		_stop_condition.individual_generated(individual)
	
	return individual_generator.source_texture
	
func _setup():
	_stop = false
	
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
