extends TextureButton


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
	
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	image_generation.stop()
