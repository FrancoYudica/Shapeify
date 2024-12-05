extends VBoxContainer

@onready var individual_count := $IndividualCountSpinBox
@onready var _params := Globals \
						.settings \
						.image_generator_params
						
func _ready() -> void:
	individual_count.value = _params.stop_condition_params.individual_count
	individual_count.value_changed.connect(
		func(value):
			_params.stop_condition_params.individual_count = value
	)

func _process(delta: float) -> void:
	visible = _params.stop_condition == StopCondition.Type.INDIVIDUAL_COUNT
