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
