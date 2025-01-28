class_name ImageProcessor extends RefCounted

enum Type
{
	GAUSSIAN_BLUR,
	SOBEL_EDGE_DETECTION,
	MULTIPLY
}

func process_image(texture: RendererTexture) -> RendererTexture:
	return null

static func factory_create(type: Type) -> ImageProcessor:
	match type:
		Type.GAUSSIAN_BLUR:
			return load("res://generation/image_processing/gaussian_blur.gd").new()
		Type.SOBEL_EDGE_DETECTION:
			return load("res://generation/image_processing/sobel_edge_detection_processor.gd").new()
		Type.MULTIPLY:
			return load("res://generation/image_processing/multiply_image_processor.gd").new()
		_:
			push_error("Unimplemented type: %s" % type)
			return null
