extends StopCondition

var _current_fitness := 0.0
var _target_fitness := 0.0

func began_generating():
	_current_fitness = 0.0
	
func individual_generated(individual: Individual):
	_current_fitness = individual.fitness
	
func should_stop() -> bool:
	return _current_fitness >= _target_fitness

func get_progress() -> float:
	var delta_fitness = clampf(_target_fitness - _current_fitness, 0.0, 1.0)
	return 1.0 - delta_fitness

func set_params(params: StopConditionParams) -> void:
	_target_fitness = params.target_fitness
