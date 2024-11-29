extends PanelContainer


@export var _individual_count: SpinBox
@onready var _params := Globals.settings.image_generator_params

func _ready() -> void:
	_individual_count.value = _params.individual_count

func _on_individual_count_spin_box_value_changed(value: float) -> void:
	_params.individual_count = value
