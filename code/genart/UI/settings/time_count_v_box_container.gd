
extends VBoxContainer

@onready var execution_time := $ExecutionTimeSpinBox
@onready var _params := Globals \
						.settings \
						.image_generator_params
						
func _ready() -> void:
	execution_time.value = _params.stop_condition_params.execution_time
	execution_time.value_changed.connect(
		func(value):
			_params.stop_condition_params.execution_time = value
	)

func _process(delta: float) -> void:
	visible = _params.stop_condition == StopCondition.Type.EXECUTION_TIME
