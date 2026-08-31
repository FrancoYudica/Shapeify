extends Node

@export var min_as_value: SpinBox
@export var max_as_value: SpinBox
var _params : ShapeAspectRatioFixParams:
	get:
		return Globals.settings.image_generator_params.shape_generator_params.shape_aspect_ratio_fix_params
						
func _ready() -> void:
	
	min_as_value.value_changed.connect(
		func(value):
			_params.random_range_aspect_ratio_min = value
	)
	
	max_as_value.value_changed.connect(
		func(value):
			_params.random_range_aspect_ratio_max = value
	)

	Globals.image_generator_params_updated.connect(_update)
	_update()
	
func _update():
	min_as_value.value = _params.random_range_aspect_ratio_min
	max_as_value.value = _params.random_range_aspect_ratio_max
