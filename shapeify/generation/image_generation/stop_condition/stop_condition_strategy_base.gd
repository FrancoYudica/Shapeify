class_name StopCondition extends RefCounted

enum Type
{
	SHAPE_COUNT,
	EXECUTION_TIME,
	METRIC_VALUE
}


func began_generating():
	pass

func shape_generated(
	source_texture: LocalTexture,
	target_texture: LocalTexture,
	shape: Shape):
	pass
	
func should_stop() -> bool:
	return true

func get_progress() -> float:
	return 0.0

func set_params(params: StopConditionParams) -> void:
	pass

static func factory_create(type: Type) -> StopCondition:
	match type:
		Type.SHAPE_COUNT:
			return load("res://generation/image_generation/stop_condition/shape_count_stop_condition.gd").new()
		Type.EXECUTION_TIME:
			return load("res://generation/image_generation/stop_condition/execution_time_stop_condition.gd").new()
		Type.METRIC_VALUE:
			return load("res://generation/image_generation/stop_condition/metric_value_stop_condition.gd").new()
		_:
			push_error("Unimplemented StopCondition %s" % Type.keys()[type])
			return null
