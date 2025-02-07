extends ShapeColorPostProcessingShader

var params: HueShiftPostProcessingShaderParams

func process_color(
	index: int,
	t: float,
	shape: Shape) -> Color:
	
	var src_color = shape.tint
	var out_color = Color(src_color)
	
	if params.random_hue_shift:
		seed(index)
		out_color.h += (randf() * 2.0 - 1.0) * params.hue_shift
	else:
		out_color.h += params.hue_shift
	
	return out_color
	
func set_params(params: ShapeColorPostProcessingShaderParams):
	self.params = params.hue_shift_params
