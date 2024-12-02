extends PanelContainer


@export var keep_aspect_ratio: CheckBox
@export var clamp_position: CheckBox
@export var fixed_rotation: CheckBox
@export var fixed_rotation_value: SpinBox

var _params: PopulatorParams
@onready var _ind_gen_params := Globals.settings.image_generator_params.individual_generator_params

func _ready() -> void:
	_params = Globals.settings.image_generator_params.individual_generator_params.populator_params
	keep_aspect_ratio.button_pressed = _ind_gen_params.keep_aspect_ratio
	clamp_position.button_pressed = _ind_gen_params.clamp_position_in_canvas
	fixed_rotation.button_pressed = _ind_gen_params.fixed_rotation
	fixed_rotation_value.editable = _ind_gen_params.fixed_rotation
	fixed_rotation_value.value = rad_to_deg(_ind_gen_params.fixed_rotation_angle)
	
	keep_aspect_ratio.toggled.connect(
		func(toggled_on):
			_ind_gen_params.keep_aspect_ratio = toggled_on
	)
	
	clamp_position.toggled.connect(
		func(toggled_on):
			_ind_gen_params.clamp_position_in_canvas = toggled_on
	)
	
	fixed_rotation.toggled.connect(
		func(toggled_on):
			_ind_gen_params.fixed_rotation = toggled_on
			fixed_rotation_value.editable = toggled_on
	)
	
	fixed_rotation_value.value_changed.connect(
		func(value):
			_ind_gen_params.fixed_rotation_angle = deg_to_rad(value)
	)
	
	
func _on_population_size_spin_box_value_changed(value: float) -> void:
	_params.population_size = value
