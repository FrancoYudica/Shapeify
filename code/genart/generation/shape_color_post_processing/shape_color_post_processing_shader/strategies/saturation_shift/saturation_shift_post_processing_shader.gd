extends ShapeColorPostProcessingShader

var params: SaturationShiftPostProcessingShaderParams

## Must use local random number generator to avoid messing up the algorithm
var rng = RandomNumberGenerator.new()

func process_color(
	index: int,
	t: float,
	shape: Shape) -> Color:
	
	var out_color = Color(shape.tint)

	if params.random_shift:
		rng.seed = index
		out_color.s += (rng.randf() * 2.0 - 1.0) * params.shift
	else:
		out_color.s += params.shift
	
	return out_color
	
func set_params(params: ShapeColorPostProcessingShaderParams):
	self.params = params.saturation_shift_params
