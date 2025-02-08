extends ShapeColorPostProcessingShader

var params: RGBShiftPostProcessingShaderParams

## Must use local random number generator to avoid messing up the algorithm
var rng = RandomNumberGenerator.new()

func process_color(
	index: int,
	t: float,
	shape: Shape) -> Color:
	
	var out_color = Color(shape.tint)
	
	rng.seed = index
	if params.random_shift:
		out_color.r += (rng.randf() * 2.0 - 1.0) * params.red_shift
		out_color.g += (rng.randf() * 2.0 - 1.0) * params.green_shift
		out_color.b += (rng.randf() * 2.0 - 1.0) * params.blue_shift
		
	else:
		out_color.r += params.red_shift
		out_color.g += params.green_shift
		out_color.b += params.blue_shift

	return out_color
	
func set_params(params: ShapeColorPostProcessingShaderParams):
	self.params = params.rgb_shift_params
