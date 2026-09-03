extends Slider

func _ready() -> void:
	value_changed.connect(
		func(value):
			Globals.settings.image_generator_params.user_mask_params.brush_size = value)
