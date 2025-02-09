extends Button

@export var image_generation: Node

func _ready() -> void:
	
	Globals.generation_started.connect(
		func():
			disabled = true
	)
	Globals.generation_finished.connect(
		func():
			disabled = false
	)
	
	pressed.connect(image_generation.clear_progress)
