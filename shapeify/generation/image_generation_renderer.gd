class_name ImageGenerationRenderer extends RefCounted


static func render_image_generation(
	renderer: LocalRenderer,
	details: ImageGenerationDetails):
	
	var viewport_size = Vector2(
		details.viewport_size.x,
		details.viewport_size.y)

	renderer.begin_frame(viewport_size)
	
	# Renders background
	renderer.render_clear(details.clear_color)
	
	# Renders shapes
	for shape in details.shapes:
		renderer.render_sprite(
			shape.position * viewport_size,
			shape.size * viewport_size,
			shape.rotation,
			shape.tint,
			shape.texture,
			1.0)
	renderer.end_frame()
