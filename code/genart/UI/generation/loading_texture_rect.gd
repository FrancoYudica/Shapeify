extends TextureRect

func _process(delta: float) -> void:
	rotation += abs(sin(Time.get_ticks_msec() * 0.002)) * 0.2
