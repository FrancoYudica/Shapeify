extends Label

@export var animator: Control

func _process(delta: float) -> void:
	if is_visible_in_tree():
		text = "%sx%s" % [
			Globals.settings.image_generator_params.target_texture.get_width(),
			Globals.settings.image_generator_params.target_texture.get_height()
		]
