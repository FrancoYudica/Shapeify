extends TextureRect


@export var image_generation: Node


func _ready() -> void:
	
	visible = false
	
	image_generation.generation_started.connect(
		func():
			visible = true
	)
	image_generation.generation_finished.connect(
		func():
			visible = false
	)
	
func _process(delta: float) -> void:
	rotation += abs(sin(Time.get_ticks_msec() * 0.002)) * 0.2
