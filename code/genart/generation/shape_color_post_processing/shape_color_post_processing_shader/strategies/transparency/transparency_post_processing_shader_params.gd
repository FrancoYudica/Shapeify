class_name TransparencyPostProcessingShaderParams extends Resource

@export var transparency: float = 0.5:
	set(value):
		if value != transparency:
			transparency = value
			emit_changed()
