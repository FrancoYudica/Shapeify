extends WeightTextureGenerator

var _mpa_image_processor: MPAImageProcessor
var _gaussian_image_processor: GaussianBlurImageProcessor
var _multiply_image_processor: MultiplyImageProcessor

var _max_texture_scalar_function: TextureScalarFunction

func _init() -> void:
	
	# Creates image processors
	_mpa_image_processor = ImageProcessor.factory_create(ImageProcessor.Type.MPA)
	_gaussian_image_processor = ImageProcessor.factory_create(ImageProcessor.Type.GAUSSIAN_BLUR)
	_multiply_image_processor = ImageProcessor.factory_create(ImageProcessor.Type.MULTIPLY)
	
	# Texture scalar functions
	_max_texture_scalar_function = TextureScalarFunction.factory_create(TextureScalarFunction.Type.MAX)


func generate(
	progress: float,
	target_texture: RendererTexture,
	source_texture: RendererTexture) -> RendererTexture:
	
	_gaussian_image_processor.iterations = 20
	_gaussian_image_processor.kernel_size = lerp(32, 5, progress)
	_gaussian_image_processor.sigma = 5
	
	_mpa_image_processor.power = 10.0
	_mpa_image_processor.src_texture = source_texture
	var mpa = _mpa_image_processor.process_image(target_texture)
	var blurred = _gaussian_image_processor.process_image(mpa)
	
	# Then normalizes texture
	var max = _max_texture_scalar_function.evaluate(blurred)
	_multiply_image_processor.multiply_value = 1.0 / max
	var normalized_texture = _multiply_image_processor.process_image(blurred)

	return normalized_texture
