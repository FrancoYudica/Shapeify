class_name IndividualRenderer extends Node

var _source_texture_size: Vector2i = Vector2i.ZERO

var source_texture_rd_rid: RID:
	set(texture):
		
		if not texture.is_valid() or not Renderer.rd.texture_is_valid(texture):
			printerr("Trying to assign invalid source_texture_rd_rid to IndividualRenderer")
			return
		
		source_texture_rd_rid = texture
		var format = Renderer.rd.texture_get_format(texture)
		_source_texture_size.x = format.width
		_source_texture_size.y = format.height
		

## Clears all the connected callables
func clear_signals():
	for s in get_signal_list():
		for conn in get_signal_connection_list(s.name):
			self.disconnect(s.name, conn.callable)

func render_individual(individual: Individual) -> void:
	
	if not source_texture_rd_rid.is_valid() or \
	   not Renderer.rd.texture_is_valid(source_texture_rd_rid):
		printerr("Trying to render individual with inavlid source_texture_rd_rid")
		return
	
	
	var clock = Clock.new()
	
	Renderer.begin_frame(_source_texture_size)
	
	# 1. Render source sprite
	Renderer.render_sprite_texture_rd_rid(
		_source_texture_size * 0.5, 
		_source_texture_size, 
		0, 
		Color.WHITE, 
		source_texture_rd_rid,
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

func get_color_attachment_texture_rd_rid() -> RID:
	return Renderer.get_attachment_texture_rd_rid(Renderer.FramebufferAttachment.COLOR)

func get_id_attachment_texture_rd_rid() -> RID:
	return Renderer.get_attachment_texture_rd_rid(Renderer.FramebufferAttachment.UID)
