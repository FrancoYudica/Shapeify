class_name SaturationShiftPostProcessingShaderParams extends Resource

@export var shift: float = 0.25:
	set(value):
		if value != shift:
			shift = value
			emit_changed()

@export var random_shift: bool = false:
	set(value):
		if value != random_shift:
			random_shift = value
			emit_changed()
