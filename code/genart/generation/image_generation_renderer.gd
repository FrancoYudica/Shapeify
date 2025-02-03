class_name ImageGenerationRenderer extends RefCounted


static func render_image_generation(
	renderer,
	details: ImageGenerationDetails):
	
	var viewport_size = details.viewport_size / details.render_scale
	renderer.begin_frame(viewport_size)
	
	# Renders background
	renderer.render_clear(details.clear_color)
	
	# Renders shapes
	for shape in details.shapes:
		renderer.render_sprite(
			shape.position / details.render_scale,
			shape.size / details.render_scale,
			shape.rotation,
			shape.tint,
			shape.texture,
			1.0)
	renderer.end_frame()
