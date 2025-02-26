extends ShapeColorPostProcessingShader

var params: RGBShiftPostProcessingShaderParams

var _noise_image: Image

func process_color(
	index: int,
	t: float,
	shape: Shape) -> Color:
	
	var out_color = Color(shape.tint)
	
	var shift_weight = 1.0
	
	if params.random_shift:

		var uv = clamp(shape.position, Vector2.ZERO, Vector2.ONE)
		var noise_pixel = Vector2i(
			clampi((_noise_image.get_width() - 1) * uv.x, 0, _noise_image.get_width() - 1),
			clampi((_noise_image.get_height() - 1) * uv.y, 0, _noise_image.get_height() - 1))
			
		var noise_value = _noise_image.get_pixel(noise_pixel.x, noise_pixel.y).r
		shift_weight = noise_value * 2.0 - 1.0
		
	out_color.r += shift_weight * params.red_shift
	out_color.g += shift_weight * params.green_shift
	out_color.b += shift_weight * params.blue_shift

	return out_color
	

var _noise_settings: NoiseSettings

func set_params(params: ShapeColorPostProcessingShaderParams):
	self.params = params.rgb_shift_params
	# Updates noise texture
	if not self.params.noise_settings.equals(_noise_settings):
		
		_noise_settings = self.params.noise_settings.duplicate()
		_noise_image = NoiseSettings.create_fast_noise_image(_noise_settings)
