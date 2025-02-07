class_name ShapeColorPostProcessingShaderParams extends Resource

@export var type := ShapeColorPostProcessingShader.Type.HUE_SHIFT

@export var hue_shift_params := HueShiftPostProcessingShaderParams.new()


func _init() -> void:
	hue_shift_params.changed.connect(emit_changed)
