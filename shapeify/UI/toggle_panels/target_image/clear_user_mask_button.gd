extends Button

func _ready() -> void:
	pressed.connect(
		func():
			Globals.settings.image_generator_params.user_mask_params.clear())
