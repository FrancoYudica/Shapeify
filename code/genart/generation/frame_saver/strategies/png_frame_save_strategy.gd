extends FrameSaver

func save(
	filepath: String,
	shapes: Array[Shape],
	clear_color: Color,
	viewport_size: Vector2i) -> bool:

	var render_details := ImageGenerationDetails.new()
	render_details.shapes = shapes
	render_details.clear_color = clear_color
	render_details.viewport_size = viewport_size
	
	# Renders the shapes
	ImageGenerationRenderer.render_image_generation(Renderer, render_details)
	
	# Gets renderer output texture
	var color_attachment_texture = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)
	var color_attachment_data = Renderer.rd.texture_get_data(color_attachment_texture.rd_rid, 0)

	# Transforms to image and saves
	var img = ImageUtils.create_image_from_rgba8_buffer(
		render_details.viewport_size.x,
		render_details.viewport_size.y,
		color_attachment_data
	)
	
	# Converts image format from RGBA32F to RGBA8. This is necessary to allow saving transparency
	img.convert(Image.FORMAT_RGBA8)
	
	if img == null:
		Notifier.notify_error("Unable to create image")
		return false
	
	if img.save_png(filepath) == OK and not silent:
		Notifier.notify_info(
			"Successfully saved PNG image at: %s" % filepath,
			filepath)
	
	return true
	
func get_extension() -> String:
	return ".png"
