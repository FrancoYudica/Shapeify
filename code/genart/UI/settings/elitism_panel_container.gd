extends PanelContainer

@onready var elitism_rate := $MarginContainer/ElitismRateSpinBox

@onready var _params := Globals \
						.settings \
						.image_generator_params \
						.individual_generator_params \
						.genetic_params

func _ready() -> void:
	elitism_rate.value = _params.survivor_selection_params.elitisim_rate * 100.0
	elitism_rate.value_changed.connect(
		func(value):
			_params.survivor_selection_params.elitisim_rate = value * 0.01
	)

func _process(delta: float) -> void:
	visible = _params.survivor_selection_strategy == SurvivorSelectionStrategy.Type.ELITISM
