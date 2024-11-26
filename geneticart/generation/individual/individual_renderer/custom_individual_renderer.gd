extends IndividualRenderer

func render_individual(individual: Individual) -> void:

	if source_texture == null:
		printerr("begin_rendering(): Source texture is null")
		return RID()
	
	var clock = Clock.new()
	
	var viewport_size = Vector2i(
		source_texture.get_width(), 
		source_texture.get_height())
		
	Renderer.begin_frame(viewport_size)
	
	# 1. Render source sprite
	Renderer.render_sprite(
		viewport_size * 0.5, 
		viewport_size, 
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

func get_color_attachment_texture_rd_id() -> RID:
	return Renderer.get_attachment_texture_rd_id(Renderer.FramebufferAttachment.COLOR)

func get_id_attachment_texture_rd_id() -> RID:
	return Renderer.get_attachment_texture_rd_id(Renderer.FramebufferAttachment.UID)
