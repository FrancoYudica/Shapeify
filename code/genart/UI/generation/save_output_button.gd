extends TextureButton

@export var image_generation: Node
@export var output_texture_rect: TextureRect
@export var save_dialog: Control

func _ready() -> void:
	
	disabled = true
	modulate = Color.DARK_GRAY
	
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
	save_dialog.open(image_generation.image_generation_details)
