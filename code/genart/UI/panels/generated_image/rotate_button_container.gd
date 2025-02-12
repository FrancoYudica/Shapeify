extends Button

@export var split_container: SplitContainer

func _ready() -> void:
	pressed.connect(
		func():
			split_container.vertical = not split_container.vertical
	)
	
	ImageGeneration.target_texture_updated.connect(
		func():
			var target_texture = Globals.settings.image_generator_params.target_texture
			split_container.vertical = target_texture.get_height() < target_texture.get_width()
	)
