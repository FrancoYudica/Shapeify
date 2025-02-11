class_name ShapeColorPostProcessingShaderParams extends Resource

@export var type := ShapeColorPostProcessingShader.Type.HUE_SHIFT

@export var enabled := true:
	set(value):
		if value != enabled:
			enabled = value
			emit_changed()

@export var hue_shift_params := HueShiftPostProcessingShaderParams.new()
@export var saturation_shift_params := SaturationShiftPostProcessingShaderParams.new()
@export var value_shift_params := ValueShiftPostProcessingShaderParams.new()
@export var transparency_params := TransparencyPostProcessingShaderParams.new()
@export var rgb_shift_params := RGBShiftPostProcessingShaderParams.new()

func setup_signals():

	hue_shift_params.setup_signals()
	saturation_shift_params.setup_signals()
	value_shift_params.setup_signals()
	transparency_params.setup_signals()
	rgb_shift_params.setup_signals()

	hue_shift_params.changed.connect(emit_changed)
	saturation_shift_params.changed.connect(emit_changed)
	value_shift_params.changed.connect(emit_changed)
	transparency_params.changed.connect(emit_changed)
	rgb_shift_params.changed.connect(emit_changed)
