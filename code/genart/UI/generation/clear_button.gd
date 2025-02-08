extends Button

@export var image_generation: Node

func _ready() -> void:
	
	image_generation.generation_started.connect(
		func():
			disabled = true
	)
	image_generation.generation_finished.connect(
		func():
			disabled = false
	)
	
	pressed.connect(image_generation.clear_progress)
