extends Button

@export var image_generation: Node

func _ready() -> void:
	
	image_generation.generation_started.connect(
		func():
			visible = false
	)
	image_generation.generation_finished.connect(
		func():
			visible = true
	)
	
	pressed.connect(image_generation.generate)
