extends Node

@export var clear_color: ColorPickerButton
var _params : ImageGeneratorParams:
	get:
		return Globals.settings.image_generator_params
						
func _ready() -> void:
	clear_color.color_changed.connect(
		func(value):
			_params.clear_color_params.color = value
	)

	Globals.image_generator_params_updated.connect(_update)
	_update()
	
func _update():
	clear_color.color = _params.clear_color_params.color
