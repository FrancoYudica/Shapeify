extends VBoxContainer

@export var shape_count_spin_box: SpinBox
var _params : ImageGeneratorParams:
	get:
		return Globals.settings.image_generator_params
						
func _ready() -> void:
	shape_count_spin_box.value_changed.connect(
		func(value):
			_params.stop_condition_params.shape_count = value
	)

	Globals.image_generator_params_updated.connect(_update)
	_update()
	
func _update():
	shape_count_spin_box.value = _params.stop_condition_params.shape_count

func _process(delta: float) -> void:
	visible = _params.stop_condition == StopCondition.Type.SHAPE_COUNT
