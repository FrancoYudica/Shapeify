extends Node

@export var tournament_size_spin_box: SpinBox

var _params : GeneticShapeGeneratorParams:
	get:
		return Globals \
				.settings \
				.image_generator_params \
				.shape_generator_params \
				.genetic_params

func _ready() -> void:
	tournament_size_spin_box.value_changed.connect(
		func(value):
			_params.survivor_selection_params.tournament_size = value
	)

	Globals.image_generator_params_updated.connect(_update)
	_update()
	
func _update():
	tournament_size_spin_box.value = _params.survivor_selection_params.tournament_size
