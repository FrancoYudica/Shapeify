class_name ShapeColorPostProcessingShaderParams extends Resource

@export var type := ShapeColorPostProcessingShader.Type.HUE_SHIFT

@export var hue_shift_params := HueShiftPostProcessingShaderParams.new()
@export var saturation_shift_params := SaturationShiftPostProcessingShaderParams.new()
@export var value_shift_params := ValueShiftPostProcessingShaderParams.new()

func setup_signals():
	hue_shift_params.changed.connect(emit_changed)
	saturation_shift_params.changed.connect(emit_changed)
	value_shift_params.changed.connect(emit_changed)
