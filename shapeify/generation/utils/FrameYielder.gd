class_name FrameYielder extends RefCounted

const DEFAULT_BUDGET_MSEC := 16

var _budget_msec: int
var _last_yield_time_msec: int

func _init(budget_msec: int = DEFAULT_BUDGET_MSEC) -> void:
	_budget_msec = budget_msec
	_last_yield_time_msec = Time.get_ticks_msec()


func maybe_yield() -> void:
	if Time.get_ticks_msec() - _last_yield_time_msec >= _budget_msec:
		await Engine.get_main_loop().process_frame
		_last_yield_time_msec = Time.get_ticks_msec()
