extends StopCondition

var _start_ms: float
var _target_execution_time: float = 1.0

func began_generating():
	_start_ms = Time.get_ticks_msec()

func should_stop() -> bool:
	var elapsed_ms = Time.get_ticks_msec() - _start_ms
	var elapsed_sec = elapsed_ms * 0.001
	return elapsed_sec >= _target_execution_time
	
func get_progress() -> float:
	var elapsed_ms = Time.get_ticks_msec() - _start_ms
	var elapsed_sec = elapsed_ms * 0.001
	return clampf(elapsed_sec / _target_execution_time, 0.0, 1.0)

func set_params(params: StopConditionParams) -> void:
	_target_execution_time = params.execution_time
