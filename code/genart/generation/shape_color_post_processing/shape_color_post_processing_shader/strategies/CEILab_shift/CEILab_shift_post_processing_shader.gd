extends ShapeColorPostProcessingShader

var params: CEILabShiftPostProcessingShaderParams

var _rng := RandomNumberGenerator.new()

func process_color(
	index: int,
	t: float,
	shape: Shape) -> Color:
	
	var out_color = Color(shape.tint)
	
	var ceilab_color = CEILabUtils.rgb2lab(Vector3(out_color.r, out_color.g, out_color.b))
	_rng.seed = index
	if params.random_shift:
		
		ceilab_color.x += params.lightness * (_rng.randf() * 2.0 - 1.0)
		ceilab_color.y += params.green_red_axis * (_rng.randf() * 2.0 - 1.0)
		ceilab_color.z += params.blue_yellow_axis * (_rng.randf() * 2.0 - 1.0)
	else:
		ceilab_color.x += params.lightness
		ceilab_color.y += params.green_red_axis
		ceilab_color.z += params.blue_yellow_axis

	var final_color = CEILabUtils.lab2rgb(ceilab_color)
	return Color(final_color.x, final_color.y, final_color.z, out_color.a)



func set_params(params: ShapeColorPostProcessingShaderParams):
	self.params = params.CEILab_shift_params
