extends TextureRect


func _ready() -> void:
	
	visible = false
	
	Globals.generation_started.connect(
		func():
			visible = true
	)
	Globals.generation_finished.connect(
		func():
			visible = false
	)
	
func _process(delta: float) -> void:
	rotation += abs(sin(Time.get_ticks_msec() * 0.002)) * 0.2
