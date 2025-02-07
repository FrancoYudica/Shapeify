class_name HueShiftPostProcessingShaderParams extends Resource

@export var hue_shift: float = 0.25:
	set(value):
		if value != hue_shift:
			hue_shift = value
			emit_changed()

@export var random_hue_shift: bool = false:
	set(value):
		if value != random_hue_shift:
			random_hue_shift = value
			emit_changed()
