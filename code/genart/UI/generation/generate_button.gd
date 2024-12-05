extends TextureButton

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


func _on_pressed() -> void:
	image_generation.generate()
