class_name ImageUtils extends RefCounted

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
):
	# Creates an image with the same size and format
	var img = Image.new()
	img.set_data(
		width,
		height,
		false,
		Image.Format.FORMAT_RGBAF,
		contents)
	return img
