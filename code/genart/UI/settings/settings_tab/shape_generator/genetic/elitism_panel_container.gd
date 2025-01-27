extends PanelContainer

@onready var elitism_rate := $MarginContainer/ElitismRateSpinBox

var _params : GeneticShapeGeneratorParams:
	get:
		return Globals \
				.settings \
				.image_generator_params \
				.shape_generator_params \
				.genetic_params

func _ready() -> void:
	elitism_rate.value_changed.connect(
		func(value):
			_params.survivor_selection_params.elitisim_rate = value * 0.01
	)

	Globals.image_generator_params_updated.connect(_update)
	_update()
	
func _update():
	elitism_rate.value = _params.survivor_selection_params.elitisim_rate * 100.0

func _process(delta: float) -> void:
	visible = _params.survivor_selection_strategy == SurvivorSelectionStrategy.Type.ELITISM
