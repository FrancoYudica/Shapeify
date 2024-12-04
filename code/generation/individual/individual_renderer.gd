class_name IndividualRenderer extends RefCounted

var source_texture: RendererTexture:
	set(texture):
		
		if not texture.is_valid():
			printerr("Trying to assign invalid source_texture to IndividualRenderer")
			return
			
		source_texture = texture
		

func render_individual(individual: Individual) -> void:
	
	if not source_texture.is_valid():
		printerr("Trying to render individual with inavlid source_texture_rd_rid")
		return
	
	var clock = Clock.new()
	
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
		
	# 2. Render individual
	Renderer.render_sprite(
		individual.position,
		individual.size,
		individual.rotation,
		individual.tint,
		individual.texture,
		1.0)
	
	Renderer.end_frame()
	#clock.print_elapsed("Finished rendering")

func get_color_attachment_texture() -> RendererTexture:
	return Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)

func get_id_attachment_texture() -> RendererTexture:
	return Renderer.get_attachment_texture(Renderer.FramebufferAttachment.UID)
