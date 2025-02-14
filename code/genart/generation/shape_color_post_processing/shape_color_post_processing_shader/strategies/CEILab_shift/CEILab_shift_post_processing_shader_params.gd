class_name CEILabShiftPostProcessingShaderParams extends Resource

@export var lightness: float = 0.10:
	set(value):
		if value != lightness:
			lightness = value
			emit_changed()

@export var green_red_axis: float = 0.10:
	set(value):
		if value != green_red_axis:
			green_red_axis = value
			emit_changed()

@export var blue_yellow_axis: float = 0.10:
	set(value):
		if value != blue_yellow_axis:
			blue_yellow_axis = value
			emit_changed()

@export var random_shift: bool = false:
	set(value):
		if value != random_shift:
			random_shift = value
			emit_changed()

func setup_signals() -> void:
	pass
