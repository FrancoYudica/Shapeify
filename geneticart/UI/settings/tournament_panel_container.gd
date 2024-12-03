extends PanelContainer


@onready var tournament_size := $MarginContainer/TournamentSizeBox

@onready var _params := Globals \
						.settings \
						.image_generator_params \
						.individual_generator_params \
						.genetic_params

func _ready() -> void:
	tournament_size.value = _params.survivor_selection_params.tournament_size
	tournament_size.value_changed.connect(
		func(value):
			_params.survivor_selection_params.tournament_size = value
	)

func _process(delta: float) -> void:
	visible = _params.survivor_selection_strategy == SurvivorSelectionStrategy.Type.TOURNAMENT
