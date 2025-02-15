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
	
	var shift_weights = Vector3.ONE
	
	if params.random_shift:
		shift_weights.x = _rng.randf() * 2.0 - 1.0
		shift_weights.y = _rng.randf() * 2.0 - 1.0
		shift_weights.z = _rng.randf() * 2.0 - 1.0
	
	ceilab_color.x += params.lightness * shift_weights.x
	ceilab_color.y += params.green_red_axis * shift_weights.y
	ceilab_color.z += params.blue_yellow_axis * shift_weights.z
	
	ceilab_color = Vector3(
		clampf(ceilab_color.x, 0.0, 1.0),
		clampf(ceilab_color.y, 0.0, 1.0),
		clampf(ceilab_color.z, 0.0, 1.0))

	var final_color = CEILabUtils.lab2rgb(ceilab_color)
	return Color(final_color.x, final_color.y, final_color.z, out_color.a)

func set_params(params: ShapeColorPostProcessingShaderParams):
	self.params = params.CEILab_shift_params
