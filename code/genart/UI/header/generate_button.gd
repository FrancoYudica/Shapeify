extends Button

@export var image_generation: Node

func _ready() -> void:
	
	Globals.generation_started.connect(
		func():
			visible = false
	)
	Globals.generation_finished.connect(
		func():
			visible = true
	)
	
	pressed.connect(image_generation.generate)
