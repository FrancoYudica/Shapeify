class_name StopCondition extends RefCounted


enum Type
{
	INDIVIDUAL_COUNT,
	EXECUTION_TIME,
	TARGET_FITNESS
}


func began_generating():
	pass

func individual_generated(individual: Individual):
	pass
	
func should_stop() -> bool:
	return true

func get_progress() -> float:
	return 0.0

func set_params(params: StopConditionParams) -> void:
	pass

static func factory_create(type: Type) -> StopCondition:
	match type:
		Type.INDIVIDUAL_COUNT:
			return load("res://generation/image_generation/stop_condition/individual_count_stop_condition.gd").new()
		Type.EXECUTION_TIME:
			return load("res://generation/image_generation/stop_condition/execution_time_stop_condition.gd").new()
		Type.TARGET_FITNESS:
			return load("res://generation/image_generation/stop_condition/target_fitness_stop_condition.gd").new()
		_:
			push_error("Unimplemented StopCondition %s" % Type.keys()[type])
			return null
