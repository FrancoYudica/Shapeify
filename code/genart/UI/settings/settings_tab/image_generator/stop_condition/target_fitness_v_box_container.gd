extends VBoxContainer

@onready var target_fitness := $TargetFitnessSpinBox
var _params : ImageGeneratorParams:
	get:
		return Globals.settings.image_generator_params
						
func _ready() -> void:
	target_fitness.value_changed.connect(
		func(value):
			_params.stop_condition_params.target_fitness = value
	)
	Globals.image_generator_params_updated.connect(_update)
	_update()
	
func _update():
	target_fitness.value = _params.stop_condition_params.target_fitness
	
func _process(delta: float) -> void:
	visible = _params.stop_condition == StopCondition.Type.TARGET_FITNESS
