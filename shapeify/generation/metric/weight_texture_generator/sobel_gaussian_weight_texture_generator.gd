extends WeightTextureGenerator

var _gaussian_blur_processor: GaussianBlurImageProcessor
var _sobel_operator_processor: SobelEdgeDetectionImageProcessor
var _multiply_image_processor: MultiplyImageProcessor
var _power_image_processor: PowerImageProcessor
var _map_to_range_image_processor: MapToRangeImageProcessor

var _max_texture_scalar_function: TextureScalarFunction

func _init() -> void:
	
	_gaussian_blur_processor = GaussianBlurImageProcessor.new()
	_sobel_operator_processor = SobelEdgeDetectionImageProcessor.new()
	_multiply_image_processor = ImageProcessor.factory_create(ImageProcessor.Type.MULTIPLY)
	_power_image_processor = ImageProcessor.factory_create(ImageProcessor.Type.POWER)
	_map_to_range_image_processor = ImageProcessor.factory_create(ImageProcessor.Type.MAP_TO_RANGE)
	_map_to_range_image_processor.min_bound = 0.1
	_map_to_range_image_processor.max_bound = 1.0
	_max_texture_scalar_function = TextureScalarFunction.factory_create(TextureScalarFunction.Type.MAX)

func generate(
	progress: float,
	target_texture: LocalTexture,
	source_texture: LocalTexture) -> LocalTexture:
		
	progress = sqrt(progress)
		
	_gaussian_blur_processor.iterations = int(lerpf(50.0, 1.0, progress))
	_gaussian_blur_processor.kernel_size = int(lerpf(64, 4, progress))
	_gaussian_blur_processor.sigma = 5
	_sobel_operator_processor.threshold = lerpf(0.0, 0.1, progress)
	
	var edges_magnitude = _sobel_operator_processor.process_image(target_texture)
	var blurred_edges = _gaussian_blur_processor.process_image(edges_magnitude)
	
	var max = _max_texture_scalar_function.evaluate(blurred_edges)
	
	_multiply_image_processor.multiply_value = 1.0 / max
	var normalized_texture = _multiply_image_processor.process_image(blurred_edges)
	
	# Adds some contrast by applying a power
	_power_image_processor.power_value = 1.5
	var output = _power_image_processor.process_image(normalized_texture)
	return output
