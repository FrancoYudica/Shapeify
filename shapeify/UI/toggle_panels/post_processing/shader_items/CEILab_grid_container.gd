extends GridContainer

@export var item: Control
@export var lightness_shift_spin_box: SpinBox
@export var green_red_shift_spin_box: SpinBox
@export var blue_yellow_shift_spin_box: SpinBox
@export var randomize_check_box: CheckBox

var _params: CEILabShiftPostProcessingShaderParams:
	get:
		return item.params.CEILab_shift_params
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	lightness_shift_spin_box.value_changed.connect(
		func(value):
			_params.lightness = value
	)
	lightness_shift_spin_box.value = _params.lightness

	green_red_shift_spin_box.value_changed.connect(
		func(value):
			_params.green_red_axis = value
	)
	green_red_shift_spin_box.value = _params.green_red_axis

	blue_yellow_shift_spin_box.value_changed.connect(
		func(value):
			_params.blue_yellow_axis = value
	)
	blue_yellow_shift_spin_box.value = _params.blue_yellow_axis

	randomize_check_box.toggled.connect(
		func(toggled_on):
			_params.random_shift = toggled_on
	)
	randomize_check_box.button_pressed = _params.random_shift
	
