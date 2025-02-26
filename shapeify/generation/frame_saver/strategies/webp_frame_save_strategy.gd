extends FrameSaver

func save(
	filepath: String,
	local_renderer: LocalRenderer,
	master_renderer_params: MasterRendererParams,
	viewport_size: Vector2i) -> bool:

	# Renders the shapes and gets renderer output texture
	MasterRenderer.render(local_renderer, viewport_size, master_renderer_params)
	var color_attachment_texture = local_renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.COLOR)
	var img = color_attachment_texture.create_image()
	
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
