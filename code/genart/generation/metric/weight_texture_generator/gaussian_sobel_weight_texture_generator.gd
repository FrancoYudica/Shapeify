extends WeightTextureGenerator

var _gaussian_blur_processor: GaussianBlurImageProcessor
var _sobel_operator_processor: SobelEdgeDetectionImageProcessor
var _multiply_image_processor: MultiplyImageProcessor
var _power_image_processor: PowerImageProcessor

var _max_texture_scalar_function: TextureScalarFunction

func _init() -> void:
	
	_gaussian_blur_processor = ImageProcessor.factory_create(ImageProcessor.Type.GAUSSIAN_BLUR)
	_sobel_operator_processor = ImageProcessor.factory_create(ImageProcessor.Type.SOBEL_EDGE_DETECTION)
	_multiply_image_processor = ImageProcessor.factory_create(ImageProcessor.Type.MULTIPLY)
	_power_image_processor = ImageProcessor.factory_create(ImageProcessor.Type.POWER)
	_max_texture_scalar_function = TextureScalarFunction.factory_create(TextureScalarFunction.Type.MAX)


func generate(
	progress: float,
	target_texture: RendererTexture,
	source_texture: RendererTexture) -> RendererTexture:
	
	var t = sqrt(progress)
	
	_gaussian_blur_processor.iterations = int(lerpf(50.0, 1.0, t))
	_gaussian_blur_processor.kernel_size = int(lerpf(64, 4, t))
	_gaussian_blur_processor.sigma = 5
	_sobel_operator_processor.threshold = 0.005
	_sobel_operator_processor.power = 0.5
	
	var blurred = _gaussian_blur_processor.process_image(target_texture)
	var edges_magnitude = _sobel_operator_processor.process_image(blurred)
	
	_power_image_processor.power_value = 2.0
	edges_magnitude = _power_image_processor.process_image(edges_magnitude)
	
	_multiply_image_processor.multiply_value = 0.2
	edges_magnitude = _multiply_image_processor.process_image(edges_magnitude)
	
	var max = _max_texture_scalar_function.evaluate(edges_magnitude)
	
	_multiply_image_processor.multiply_value = 1.0 / max
	var normalized_texture = _multiply_image_processor.process_image(edges_magnitude)
	
	return normalized_texture
