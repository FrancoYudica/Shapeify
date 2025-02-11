extends GridContainer

@export var item: Control
@export var red_shift_spin_box: SpinBox
@export var green_shift_spin_box: SpinBox
@export var blue_shift_spin_box: SpinBox
@export var randomize_check_box: CheckBox
@export var noise_settings_panel: Control

var _params: RGBShiftPostProcessingShaderParams:
	get:
		return item.params.rgb_shift_params
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	red_shift_spin_box.value_changed.connect(
		func(value):
			_params.red_shift = value
	)
	green_shift_spin_box.value_changed.connect(
		func(value):
			_params.green_shift = value
	)
	blue_shift_spin_box.value_changed.connect(
		func(value):
			_params.blue_shift = value
	)
	red_shift_spin_box.value = _params.red_shift
	green_shift_spin_box.value = _params.green_shift
	blue_shift_spin_box.value = _params.blue_shift
	
	randomize_check_box.toggled.connect(
		func(toggled_on):
			_params.random_shift = toggled_on
			noise_settings_panel.disabled = not toggled_on
	)
	randomize_check_box.button_pressed = _params.random_shift
	noise_settings_panel.disabled = not _params.random_shift
	noise_settings_panel.noise_settings = _params.noise_settings
	
