extends PanelContainer


@export var population_size_spin_box: SpinBox
@export var box_size: CheckBox
@export var random_rotation: CheckBox

var _params: PopulatorParams

func _ready() -> void:
	_params = Globals.settings.image_generator_params.individual_generator_params.populator_params
	population_size_spin_box.value = _params.population_size
	box_size.button_pressed = _params.box_size
	random_rotation.button_pressed = _params.random_rotation

func _on_box_size_check_box_toggled(toggled_on: bool) -> void:
	_params.box_size = toggled_on

func _on_random_rotation_check_box_toggled(toggled_on: bool) -> void:
	_params.random_rotation = toggled_on

func _on_population_size_spin_box_value_changed(value: float) -> void:
	_params.population_size = value
