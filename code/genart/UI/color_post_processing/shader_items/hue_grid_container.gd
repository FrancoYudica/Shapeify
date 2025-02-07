extends GridContainer

@export var item: Control
@export var value_spin_box: SpinBox
@export var randomize_check_box: CheckBox

var _params: HueShiftPostProcessingShaderParams:
	get:
		return item.params.hue_shift_params
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	value_spin_box.value_changed.connect(
		func(value):
			_params.hue_shift = value
	)
	
	value_spin_box.value = _params.hue_shift
	
	randomize_check_box.toggled.connect(
		func(toggled_on):
			_params.random_hue_shift = toggled_on
	)
	
	randomize_check_box.button_pressed = _params.random_hue_shift
	
