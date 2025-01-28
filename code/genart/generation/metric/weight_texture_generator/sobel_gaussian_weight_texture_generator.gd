extends WeightTextureGenerator

var _gaussian_blur_processor: GaussianBlurImageProcessor
var _sobel_operator_processor: SobelEdgeDetectionImageProcessor

func _init() -> void:
	
	_gaussian_blur_processor = GaussianBlurImageProcessor.new()
	_sobel_operator_processor = SobelEdgeDetectionImageProcessor.new()
	

func generate(
	progress: float,
	target_texture: RendererTexture) -> RendererTexture:
	
	_gaussian_blur_processor.iterations = int(lerpf(100.0, 10.0, progress))
	_gaussian_blur_processor.kernel_size = int(lerpf(9, 5, progress))
	_gaussian_blur_processor.sigma = int(lerpf(5, 1, progress))
	_sobel_operator_processor.threshold = lerpf(0.0, 0.1, progress)
	
	var blurred = _sobel_operator_processor.process_image(target_texture)
	var blurred_edges = _gaussian_blur_processor.process_image(blurred)
	return blurred_edges
