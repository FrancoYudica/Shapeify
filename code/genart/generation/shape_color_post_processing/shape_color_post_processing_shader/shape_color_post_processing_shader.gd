class_name ShapeColorPostProcessingShader extends RefCounted

enum Type
{
	HUE_SHIFT
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
		_:
			push_error("Unimplemenmted ShapeColorPostProcessingShader of type %s" % type)
			return null
