extends PanelContainer


@export var keep_aspect_ratio: CheckBox
@export var random_rotation: CheckBox
@export var clamp_position: CheckBox

var _params: PopulatorParams
@onready var _ind_gen_params := Globals.settings.image_generator_params.individual_generator_params

func _ready() -> void:
	_params = Globals.settings.image_generator_params.individual_generator_params.populator_params
	keep_aspect_ratio.button_pressed = _ind_gen_params.keep_aspect_ratio
	random_rotation.button_pressed = _ind_gen_params.random_rotation
	clamp_position.button_pressed = _ind_gen_params.clamp_position_in_canvas
	
	keep_aspect_ratio.toggled.connect(
		func(toggled_on):
			_ind_gen_params.keep_aspect_ratio = toggled_on
	)
	random_rotation.toggled.connect(
		func(toggled_on):
			_ind_gen_params.random_rotation = toggled_on
	)
	
	clamp_position.toggled.connect(
		func(toggled_on):
			_ind_gen_params.clamp_position_in_canvas = toggled_on
	)
	
func _on_population_size_spin_box_value_changed(value: float) -> void:
	_params.population_size = value
