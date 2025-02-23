class_name ValueShiftPostProcessingShaderParams extends Resource

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

@export var noise_settings := NoiseSettings.new()

func setup_signals() -> void:
	noise_settings.changed.connect(emit_changed)
