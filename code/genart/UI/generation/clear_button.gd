extends TextureButton

@export var image_generation: Node

func _ready() -> void:
	
	image_generation.generation_started.connect(
		func():
			disabled = true
			modulate = Color.DARK_GRAY

	)
	image_generation.generation_finished.connect(
		func():
			disabled = false
			modulate = Color.WHITE
	)

func _on_pressed() -> void:
	image_generation.clear_progress()
