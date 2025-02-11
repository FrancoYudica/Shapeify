extends ShapeColorPostProcessingShader

var params: ValueShiftPostProcessingShaderParams

var _noise_image: Image

func process_color(
	index: int,
	t: float,
	shape: Shape) -> Color:
	
	var out_color = Color(shape.tint)
	
	if params.random_shift:
		var uv = clamp(shape.position, Vector2.ZERO, Vector2.ONE)
		var noise_pixel = Vector2i(
			int((_noise_image.get_width() - 1) * uv.x),
			int((_noise_image.get_height() - 1) * uv.y))
			
		var noise_value = _noise_image.get_pixel(noise_pixel.x, noise_pixel.y).r

		out_color.v += (noise_value * 2.0 - 1.0) * params.shift
		
	else:
		out_color.v += params.shift
	
	return out_color


var _noise_settings: NoiseSettings

func set_params(params: ShapeColorPostProcessingShaderParams):
	self.params = params.value_shift_params

	# Updates noise texture
	if not self.params.noise_settings.equals(_noise_settings):
		_noise_settings = self.params.noise_settings.duplicate()
		_noise_image = NoiseSettings.create_fast_noise_image(_noise_settings)
