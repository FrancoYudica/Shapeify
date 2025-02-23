class_name ImageProcessor extends RefCounted

enum Type
{
	GAUSSIAN_BLUR,
	SOBEL_EDGE_DETECTION,
	ADD,
	MULTIPLY,
	POWER,
	MAP_TO_RED,
	MPA,
	MAP_TO_RANGE,
	TEXTURE_MULTIPLY
}

func process_image(texture: RendererTexture) -> RendererTexture:
	return null

static func factory_create(type: Type) -> ImageProcessor:
	match type:
		Type.GAUSSIAN_BLUR:
			return load("res://generation/image_processing/gaussian_blur.gd").new()
		Type.SOBEL_EDGE_DETECTION:
			return load("res://generation/image_processing/sobel_edge_detection_processor.gd").new()
		Type.ADD:
			return load("res://generation/image_processing/add_image_processor.gd").new()
		Type.MULTIPLY:
			return load("res://generation/image_processing/multiply_image_processor.gd").new()
		Type.POWER:
			return load("res://generation/image_processing/power_image_processor.gd").new()
		Type.MAP_TO_RED:
			return load("res://generation/image_processing/map_to_red_image_processor.gd").new()
		Type.MPA:
			return load("res://generation/image_processing/mpa_rgb_image_processor.gd").new()
		Type.MAP_TO_RANGE:
			return load("res://generation/image_processing/map_to_range_image_processor.gd").new()
		Type.TEXTURE_MULTIPLY:
			return load("res://generation/image_processing/texture_multiply_image_processor.gd").new()
		_:
			push_error("Unimplemented type: %s" % type)
			return null
