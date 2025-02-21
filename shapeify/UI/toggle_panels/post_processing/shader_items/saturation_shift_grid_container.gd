extends GridContainer

@export var item: Control
@export var value_spin_box: SpinBox
@export var randomize_check_box: CheckBox
@export var noise_settings_panel: Control

var _params: SaturationShiftPostProcessingShaderParams:
	get:
		return item.params.saturation_shift_params
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	value_spin_box.value_changed.connect(
		func(value):
			_params.shift = value
	)
	
	value_spin_box.value = _params.shift
	
	randomize_check_box.toggled.connect(
		func(toggled_on):
			_params.random_shift = toggled_on
			noise_settings_panel.disabled = not toggled_on
	)
	
	randomize_check_box.button_pressed = _params.random_shift
	noise_settings_panel.disabled = not _params.random_shift
	noise_settings_panel.noise_settings = _params.noise_settings
