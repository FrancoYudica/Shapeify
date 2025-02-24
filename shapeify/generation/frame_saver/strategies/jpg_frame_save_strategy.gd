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
	var renderer := GenerationGlobals.renderer
	ImageGenerationRenderer.render_image_generation(renderer, render_details)
	
	# Gets renderer output texture
	var color_attachment_texture = renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.COLOR)
	var img = color_attachment_texture.create_image()
	
	if img == null:
		Notifier.notify_error("Unable to create image")
		return false
	
	if img.save_jpg(filepath) == OK and not silent:
		Notifier.notify_info(
			"Successfully saved JPG image at: %s" % filepath,
			filepath)
	
	return true

func get_extension() -> String:
	return ".jpg"
