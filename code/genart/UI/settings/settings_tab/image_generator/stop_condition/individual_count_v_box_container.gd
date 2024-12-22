extends VBoxContainer

@onready var individual_count := $IndividualCountSpinBox
var _params : ImageGeneratorParams:
	get:
		return Globals.settings.image_generator_params
						
func _ready() -> void:
	individual_count.value_changed.connect(
		func(value):
			_params.stop_condition_params.individual_count = value
	)

	Globals.image_generator_params_updated.connect(_update)
	_update()
	
func _update():
	individual_count.value = _params.stop_condition_params.individual_count

func _process(delta: float) -> void:
	visible = _params.stop_condition == StopCondition.Type.INDIVIDUAL_COUNT
