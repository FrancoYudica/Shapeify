extends VBoxContainer

@export var weight_texture_generator_picker: WeightTextureGeneratorPicker

var _weight_params : WeightTextureGeneratorParams:
	get:
		return Globals.settings.image_generator_params.shape_generator_params.shape_spawner_params.shape_position_initializer_params.weight_texture_generator_params

func _ready() -> void:
	Globals.image_generator_params_updated.connect(_update)
	_update()
	
func _update():
	weight_texture_generator_picker.set_params(_weight_params)
