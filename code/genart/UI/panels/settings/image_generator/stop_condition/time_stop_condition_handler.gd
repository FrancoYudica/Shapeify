
extends Node

@export var execution_time: SpinBox
var _params : ImageGeneratorParams:
	get:
		return Globals.settings.image_generator_params
						
func _ready() -> void:
	execution_time.value_changed.connect(
		func(value):
			_params.stop_condition_params.execution_time = value
	)
	Globals.image_generator_params_updated.connect(_update)
	_update()

func _update():
	execution_time.value = _params.stop_condition_params.execution_time
