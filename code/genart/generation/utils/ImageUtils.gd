class_name ImageUtils extends RefCounted

static func is_input_format_supported(file: String) -> bool:
	
	for extension in Constants.VALID_INPUT_IMAGE_EXTENSIONS:
		if file.ends_with(extension) or file.ends_with(extension.to_upper()):
			return true
	
	return false

static func create_monochromatic_image(
	width: int,
	height: int,
	color: Color
) -> Image:
	var img = Image.create(
		width,
		height,
		false, 
		Image.FORMAT_RGBAF)
	
	img.fill(color)
	return img

static func create_image_from_rgbaf_buffer(
	width: int,
	height: int,
	contents
) -> Image:
	# Creates an image with the same size and format
	var img = Image.new()
	img.set_data(
		width,
		height,
		false,
		Image.Format.FORMAT_RGBAF,
		contents)
	return img

static var _color_sampler: AverageColorSampler

static func get_texture_average_color(texture: RendererTexture) -> Color:
	
	if _color_sampler == null:
		_color_sampler = load("res://generation/average_color_sampler/subrect/average_subrect_color_sampler.gd").new()
	
	_color_sampler.sample_texture = texture
	return _color_sampler.sample_rect(
		Rect2i(
			Vector2i.ZERO, 
			Vector2i(
				texture.get_width(),
				texture.get_height()
			)
		)
	)
