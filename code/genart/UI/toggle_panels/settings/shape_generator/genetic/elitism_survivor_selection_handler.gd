extends Node


@export var elitism_rate_spin_box: SpinBox

var _params : GeneticShapeGeneratorParams:
	get:
		return Globals \
				.settings \
				.image_generator_params \
				.shape_generator_params \
				.genetic_params

func _ready() -> void:
	elitism_rate_spin_box.value_changed.connect(
		func(value):
			_params.survivor_selection_params.elitisim_rate = value * 0.01
	)

	Globals.image_generator_params_updated.connect(_update)
	_update()
	
func _update():
	elitism_rate_spin_box.value = _params.survivor_selection_params.elitisim_rate * 100.0
