extends ShapeColorPostProcessingShader

var params: HueShiftPostProcessingShaderParams

## Must use local random number generator to avoid messing up the algorithm
var rng = RandomNumberGenerator.new()

func process_color(
	index: int,
	t: float,
	shape: Shape) -> Color:
	
	var out_color = Color(shape.tint)
	
	if params.random_hue_shift:
		rng.seed = index
		out_color.h += (rng.randf() * 2.0 - 1.0) * params.hue_shift
	else:
		out_color.h += params.hue_shift
	
	return out_color
	
func set_params(params: ShapeColorPostProcessingShaderParams):
	self.params = params.hue_shift_params
