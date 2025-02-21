extends ShapeColorPostProcessingShader

var params: TransparencyPostProcessingShaderParams


func process_color(
	index: int,
	t: float,
	shape: Shape) -> Color:
	
	var out_color = Color(shape.tint)
	out_color.a = params.transparency
	return out_color
	
func set_params(params: ShapeColorPostProcessingShaderParams):
	self.params = params.transparency_params
