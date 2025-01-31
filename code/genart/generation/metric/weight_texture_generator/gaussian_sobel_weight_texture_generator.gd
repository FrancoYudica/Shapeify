extends WeightTextureGenerator

var _gaussian_blur_processor: GaussianBlurImageProcessor
var _sobel_operator_processor: SobelEdgeDetectionImageProcessor
var _multiply_image_processor: MultiplyImageProcessor

var _max_texture_scalar_function: TextureScalarFunction

func _init() -> void:
	
	_gaussian_blur_processor = GaussianBlurImageProcessor.new()
	_sobel_operator_processor = SobelEdgeDetectionImageProcessor.new()
	_multiply_image_processor = ImageProcessor.factory_create(ImageProcessor.Type.MULTIPLY)
	_max_texture_scalar_function = TextureScalarFunction.factory_create(TextureScalarFunction.Type.MAX)


func generate(
	progress: float,
	target_texture: RendererTexture,
	source_texture: RendererTexture) -> RendererTexture:

	_gaussian_blur_processor.iterations = int(lerpf(50.0, 1.0, progress))
	_gaussian_blur_processor.kernel_size = int(lerpf(64, 4, progress))
	_gaussian_blur_processor.sigma = 5
	_sobel_operator_processor.threshold = 0.005
	_sobel_operator_processor.power = 0.5
	
	var blurred = _gaussian_blur_processor.process_image(target_texture)
	var edges_magnitude = _sobel_operator_processor.process_image(blurred)
	
	var max = _max_texture_scalar_function.evaluate(edges_magnitude)
	
	_multiply_image_processor.multiply_value = 1.0 / max
	var normalized_texture = _multiply_image_processor.process_image(edges_magnitude)
	
	return normalized_texture
