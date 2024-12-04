class_name StopConditionParams extends Resource

@export var individual_count: int = 10
@export var execution_time: float = 10
@export var target_fitness: float = 0.9

func to_dict() -> Dictionary:
	return {
		"individual_count" : individual_count,
		"execution_time" : execution_time,
		"target_fitness" : target_fitness
	}
