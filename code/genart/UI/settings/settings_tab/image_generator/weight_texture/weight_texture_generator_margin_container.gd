extends MarginContainer

@export var weight_texture_generator_picker: WeightTextureGeneratorPicker

var _params : ImageGeneratorParams:
	get:
		return Globals.settings.image_generator_params

func _ready() -> void:
	Globals.image_generator_params_updated.connect(_update)
	_update()
	
func _update():
	weight_texture_generator_picker.set_params(_params.weight_texture_generator_params)
