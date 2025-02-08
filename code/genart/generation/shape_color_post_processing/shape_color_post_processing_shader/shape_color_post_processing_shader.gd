class_name ShapeColorPostProcessingShader extends RefCounted

enum Type
{
	HUE_SHIFT,
	SATURATION_SHIFT,
	VALUE_SHIFT,
	RGB_SHIFT,
	TRANSPARENCY
}

func process_color(
	index: int,
	t: float,
	shape: Shape) -> Color:
	return Color.WHITE

func set_params(params: ShapeColorPostProcessingShaderParams):
	pass


static func factory_create(type: Type) -> ShapeColorPostProcessingShader:
	match type:
		Type.HUE_SHIFT:
			return load("res://generation/shape_color_post_processing/shape_color_post_processing_shader/strategies/hue_shift/hue_shift_post_processing_shader.gd").new()
		Type.SATURATION_SHIFT:
			return load("res://generation/shape_color_post_processing/shape_color_post_processing_shader/strategies/saturation_shift/saturation_shift_post_processing_shader.gd").new()
		Type.VALUE_SHIFT:
			return load("res://generation/shape_color_post_processing/shape_color_post_processing_shader/strategies/value_shift/value_shift_post_processing_shader.gd").new()
		Type.RGB_SHIFT:
			return load("res://generation/shape_color_post_processing/shape_color_post_processing_shader/strategies/rgb_shift/rgb_shift_post_processing_shader.gd").new()
		Type.TRANSPARENCY:
			return load("res://generation/shape_color_post_processing/shape_color_post_processing_shader/strategies/transparency/transparency_post_processing_shader.gd").new()
		_:
			push_error("Unimplemenmted ShapeColorPostProcessingShader of type %s" % type)
			return null
