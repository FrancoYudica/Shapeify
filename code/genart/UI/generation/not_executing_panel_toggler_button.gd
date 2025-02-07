extends TextureButton

@export var image_generation: Node
@export var panel: Control

func _ready() -> void:
	
	disabled = true
	modulate = Color.DARK_GRAY

	pressed.connect(
		func():
			panel.visible = not panel.visible
	)
	
	image_generation.generation_finished.connect(
		func():
			disabled = false
			modulate = Color.WHITE
	)
	
	image_generation.generation_started.connect(
		func():
			disabled = true
			modulate = Color.DARK_GRAY

	)
