class_name Clock extends RefCounted

var _t0 = 0.0


func _init() -> void:
	_t0 = Time.get_ticks_usec()

func restart():
	_t0 = Time.get_ticks_usec()

func elapsed_ms():
	return (Time.get_ticks_usec() - _t0) / 1000.0

func print_elapsed(message):
	var dt = self.elapsed_ms()
	print("%s. Elapsed %sms" % [message, dt])
