extends VBoxContainer

@onready var target_fitness := $TargetFitnessSpinBox
@onready var _params := Globals \
						.settings \
						.image_generator_params
						
func _ready() -> void:
	target_fitness.value = _params.stop_condition_params.target_fitness
	target_fitness.value_changed.connect(
		func(value):
			_params.stop_condition_params.target_fitness = value
	)

func _process(delta: float) -> void:
	visible = _params.stop_condition == StopCondition.Type.TARGET_FITNESS
