extends FrameSaver

func save(
	filepath: String,
	shapes: Array[Shape],
	clear_color: Color,
	viewport_size: Vector2i,
	viewport_scale: float) -> bool:

	var render_details := ImageGenerationDetails.new()
	render_details.clear_color = clear_color
	render_details.viewport_size = Vector2(
		viewport_size.x * viewport_scale,
		viewport_size.y * viewport_scale
	)
	for shape in shapes:
		var s = shape.copy()
		s.position *= viewport_scale
		s.size *= viewport_scale
		render_details.shapes.append(s)
	
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
	
	if img == null:
		Notifier.notify_error("Unable to create image")
		return false
	
	if img.save_webp(filepath) == OK and not silent:
		Notifier.notify_info(
			"Successfully saved WEBP image at: %s" % filepath,
			filepath)
	
	return true

func get_extension() -> String:
	return ".webp"
