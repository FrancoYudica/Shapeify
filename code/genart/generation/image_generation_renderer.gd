class_name ImageGenerationRenderer extends RefCounted


static func render_image_generation(
	renderer,
	details: ImageGenerationDetails):
	
	var viewport_size = details.viewport_size
	renderer.begin_frame(viewport_size)
	
	# Renders background
	renderer.render_clear(details.clear_color)
	
	# Renders shapes
	for individual in details.shapes:
		renderer.render_sprite(
			individual.position,
			individual.size,
			individual.rotation,
			individual.tint,
			individual.texture,
			1.0)
	renderer.end_frame()
