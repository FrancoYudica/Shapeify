extends WeightTextureGenerator

var _gaussian_a_image_processor: GaussianBlurImageProcessor
var _gaussian_b_image_processor: GaussianBlurImageProcessor
var _multiply_image_processor: MultiplyImageProcessor
var _add_image_processor: AddImageProcessor
var _map_to_red_image_processor: MapToRedImageProcessor

var _max_texture_scalar_function: TextureScalarFunction

func _init() -> void:
	
	# Creates image processors
	_gaussian_a_image_processor = ImageProcessor.factory_create(ImageProcessor.Type.GAUSSIAN_BLUR)
	_gaussian_b_image_processor = ImageProcessor.factory_create(ImageProcessor.Type.GAUSSIAN_BLUR)
	_multiply_image_processor = ImageProcessor.factory_create(ImageProcessor.Type.MULTIPLY)
	_add_image_processor = ImageProcessor.factory_create(ImageProcessor.Type.ADD)
	_map_to_red_image_processor = ImageProcessor.factory_create(ImageProcessor.Type.MAP_TO_RED)
	
	# Texture scalar functions
	_max_texture_scalar_function = TextureScalarFunction.factory_create(TextureScalarFunction.Type.MAX)


func generate(
	progress: float,
	target_texture: LocalTexture,
	source_texture: LocalTexture) -> LocalTexture:
	
	var iterations = 20
	var kernel_size = lerp(32, 5, progress)
	var small_sigma = 1.6
	var large_sigma = lerpf(12.0, 2.0, progress)
	
	# Blurs the same textuere with different parameters
	_gaussian_a_image_processor.iterations = iterations
	_gaussian_b_image_processor.iterations = iterations
	_gaussian_a_image_processor.kernel_size = kernel_size
	_gaussian_b_image_processor.kernel_size = kernel_size
	_gaussian_a_image_processor.sigma = small_sigma
	_gaussian_b_image_processor.sigma = large_sigma
	
	var blurred_a = _gaussian_a_image_processor.process_image(target_texture)
	var blurred_b = _gaussian_b_image_processor.process_image(target_texture)
	
	# Computes difference of gaussians 
	_add_image_processor.sign = -1.0
	_add_image_processor.texture_b = blurred_a
	var dog_texture = _add_image_processor.process_image(blurred_b)
	
	# Maps the differences to the red channel
	var red_texture = _map_to_red_image_processor.process_image(dog_texture)
	
	# Then normalizes texture
	var max = _max_texture_scalar_function.evaluate(red_texture)
	_multiply_image_processor.multiply_value = 1.0 / max
	var normalized_texture = _multiply_image_processor.process_image(red_texture)

	return normalized_texture
