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
		Image.FORMAT_RGBA8)
	
	img.fill(color)
	return img

static func create_image_from_rgba8_buffer(
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
		Image.Format.FORMAT_RGBA8,
		contents)
	return img
