class_name ShapeRenderer extends RefCounted


static func render_shape(
	renderer: LocalRenderer,
	source_texture: LocalTexture,
	shape: Shape) -> void:
		
	if renderer == null:
		push_error("Renderer is null")
		return
	
	if not source_texture.is_valid():
		printerr("Trying to render shape with inavlid source_texture_rd_rid")
		return
	
	var size = source_texture.get_size()
	renderer.begin_frame(size)
	
	# 1. Render source sprite
	renderer.render_sprite(
		size * 0.5, 
		size, 
		0, 
		Color.WHITE, 
		source_texture,
		0.0)
		
	# 2. Render shape
	renderer.render_sprite(
		shape.position * source_texture.get_size(),
		shape.size * source_texture.get_size(),
		shape.rotation,
		shape.tint,
		shape.texture,
		1.0)
	
	renderer.end_frame()
