extends Button

@export var image_generation: Node

func _on_pressed() -> void:
	image_generation.generate()
