class_name RGBShiftPostProcessingShaderParams extends Resource

@export var red_shift: float = 0.25:
	set(value):
		if value != red_shift:
			red_shift = value
			emit_changed()

@export var green_shift: float = 0.25:
	set(value):
		if value != green_shift:
			green_shift = value
			emit_changed()

@export var blue_shift: float = 0.25:
	set(value):
		if value != blue_shift:
			blue_shift = value
			emit_changed()

@export var random_shift: bool = false:
	set(value):
		if value != random_shift:
			random_shift = value
			emit_changed()
