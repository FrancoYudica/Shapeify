extends ShapeSizeInitializer

var _weight_image: Image
var _sobel_edge_detection: SobelEdgeDetectionImageProcessor
var _blur_processor: GaussianBlurImageProcessor
var _multiply_image_processor: MultiplyImageProcessor
var _max_texture_scalar_function: TextureScalarFunction
var _sum_texture_scalar_function: TextureScalarFunction

var _mask_weights_sum: float = 0.0

func initialize_attribute(shape: Shape) -> void:
	
	var min_ratio = .1
	var max_ratio = lerpf(0.9, min_ratio, similarity)
	
	shape.size.x = randf_range(min_ratio, max_ratio)
	shape.size.y = randf_range(min_ratio, max_ratio)

	# Samples weight texture ---------------------------------------------------
	var pixel_position = Vector2i(
		(_weight_image.get_width() - 1) * shape.position.x,
		(_weight_image.get_height() - 1) * shape.position.y
	)
	var normalized_weight = _weight_image.get_pixel(
		pixel_position.x, 
		pixel_position.y).r
	
	# Applies the size weight texture factor -----------------------------------
	var size_weight = lerpf(1.0, 0.25, normalized_weight)
	shape.size.x *= size_weight
	shape.size.y *= size_weight
	
	# Applies mask weight texture factor ---------------------------------------
	# This way, when the mask texture has less pixels painted, the size of the
	# shapes gets smaller, allowing it to focus on smaller details
	var mask_weight = lerpf(0.20, 1.0, _mask_weights_sum)
	shape.size.x *= mask_weight
	shape.size.y *= mask_weight
	

## Called when the spawner has to update it's properties
func update(
	target_texture: LocalTexture,
	source_texture: LocalTexture,
	weight_texture: LocalTexture,
	mask_texture: LocalTexture) -> void:
	
	_blur_processor.iterations = int(lerpf(10.0, 2.0, similarity))
	_blur_processor.kernel_size = int(lerpf(9, 4, similarity))
	_blur_processor.sigma = 5
	_sobel_edge_detection.threshold = lerpf(0.0, 0.1, similarity)
	
	var sobel_processed = _sobel_edge_detection.process_image(target_texture)
	var max = _max_texture_scalar_function.evaluate(sobel_processed)
	_multiply_image_processor.multiply_value = 1.0 / max
	var sobel_normalized = _multiply_image_processor.process_image(sobel_processed)
	
	var blurred_edges = _blur_processor.process_image(sobel_normalized)
	
	var size_texture = blurred_edges

	DebugSignals.updated_spawn_size_texture.emit(size_texture)

	_weight_image = ImageUtils.create_image_from_rgba8_buffer(
		size_texture.get_width(),
		size_texture.get_height(),
		size_texture.rd.texture_get_data(size_texture.rd_rid, 0)
	)
	
	_mask_weights_sum = _sum_texture_scalar_function.evaluate(mask_texture)
	_mask_weights_sum /= (mask_texture.get_width() * mask_texture.get_height() * 3.0)

func set_params(params: ShapeSpawnerParams):
	_sobel_edge_detection = ImageProcessor.factory_create(ImageProcessor.Type.SOBEL_EDGE_DETECTION)
	_blur_processor = ImageProcessor.factory_create(ImageProcessor.Type.GAUSSIAN_BLUR)
	_multiply_image_processor = ImageProcessor.factory_create(ImageProcessor.Type.MULTIPLY)
	_max_texture_scalar_function = TextureScalarFunction.factory_create(TextureScalarFunction.Type.MAX)
	_sum_texture_scalar_function = TextureScalarFunction.factory_create(TextureScalarFunction.Type.SUM)
