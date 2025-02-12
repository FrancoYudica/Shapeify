extends ShapeSizeInitializer

var _weight_image: Image
var _sobel_edge_detection: SobelEdgeDetectionImageProcessor
var _blur_processor: GaussianBlurImageProcessor
var _multiply_image_processor: MultiplyImageProcessor
var _max_texture_scalar_function: TextureScalarFunction


func initialize_attribute(shape: Shape) -> void:

	var max_ratio = lerpf(0.9, 0.1, similarity)
	var min_ratio = .1
	
	var width = randf_range(min_ratio, max_ratio)
	var height = randf_range(min_ratio, max_ratio)

	# Samples weight texture ---------------------------------------------------
	var pixel_position = Vector2i(
		(_weight_image.get_width() - 1) * shape.position.x,
		(_weight_image.get_height() - 1) * shape.position.y
	)
	var normalized_weight = _weight_image.get_pixel(
		pixel_position.x, 
		pixel_position.y).r
	
	# The weight takes more importance when converging the image
	var size = lerpf(1.0, 0.25, normalized_weight)
	shape.size.x = width * size
	shape.size.y = height * size

## Called when the spawner has to update it's properties
func update(
	target_texture: RendererTexture,
	source_texture: RendererTexture,
	weight_texture: RendererTexture) -> void:
	
	_blur_processor.iterations = int(lerpf(10.0, 1.0, similarity))
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
		Renderer.rd.texture_get_data(size_texture.rd_rid, 0)
	)


func set_params(params: ShapeSpawnerParams):
	_sobel_edge_detection = ImageProcessor.factory_create(ImageProcessor.Type.SOBEL_EDGE_DETECTION)
	_blur_processor = ImageProcessor.factory_create(ImageProcessor.Type.GAUSSIAN_BLUR)
	_multiply_image_processor = ImageProcessor.factory_create(ImageProcessor.Type.MULTIPLY)
	_max_texture_scalar_function = TextureScalarFunction.factory_create(TextureScalarFunction.Type.MAX)
