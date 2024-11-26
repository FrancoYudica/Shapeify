class_name IndividualRenderer extends Node

@export var source_texture: Texture2D = null:
	set(texture):
		source_texture = texture
		
		if is_node_ready():
			_src_texture_changed()

## Clears all the connected callables
func clear_signals():
	for s in get_signal_list():
		for conn in get_signal_connection_list(s.name):
			self.disconnect(s.name, conn.callable)

func render_individual(individual: Individual):

	if source_texture == null:
		printerr("begin_rendering(): Source texture is null")
		return

## Returns the texture that the renderer is always rendering onto
func get_color_attachment_texture_rd_id():
	return RID()

func get_id_attachment_texture_rd_id() -> RID:
	return RID()


func _src_texture_changed():
	pass
