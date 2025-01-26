class_name ShapeRenderer extends RefCounted

var source_texture: RendererTexture:
	set(texture):
		
		if not texture.is_valid():
			printerr("Trying to assign invalid source_texture to ShapeRenderer")
			return
			
		source_texture = texture
		

func render_shape(shape: Shape) -> void:
	
	if not source_texture.is_valid():
		printerr("Trying to render shape with inavlid source_texture_rd_rid")
		return
	
	var size = source_texture.get_size()
	Renderer.begin_frame(size)
	
	# 1. Render source sprite
	Renderer.render_sprite(
		size * 0.5, 
		size, 
		0, 
		Color.WHITE, 
		source_texture,
		0.0)
		
	# 2. Render shape
	Renderer.render_sprite(
		shape.position,
		shape.size,
		shape.rotation,
		shape.tint,
		shape.texture,
		1.0)
	
	Renderer.end_frame()

func get_color_attachment_texture() -> RendererTexture:
	return Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)

func get_id_attachment_texture() -> RendererTexture:
	return Renderer.get_attachment_texture(Renderer.FramebufferAttachment.UID)
