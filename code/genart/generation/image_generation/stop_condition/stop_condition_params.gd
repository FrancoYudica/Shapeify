class_name StopConditionParams extends Resource

@export var individual_count: int = 10:
	set(value):
		if value != individual_count:
			individual_count = value
			emit_changed()

@export var execution_time: float = 10:
	set(value):
		if value != execution_time:
			execution_time = value
			emit_changed()

@export var target_fitness: float = 0.9:
	set(value):
		if value != target_fitness:
			target_fitness = value
			emit_changed()

@export var metric_type := Metric.Type.DELTA_E_1994:
	set(value):
		if value != metric_type:
			metric_type = value
			emit_changed()

func to_dict() -> Dictionary:
	return {
		"individual_count" : individual_count,
		"execution_time" : execution_time,
		"target_fitness" : target_fitness
	}
