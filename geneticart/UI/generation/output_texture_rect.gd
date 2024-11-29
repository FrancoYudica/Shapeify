extends TextureRect

@export var image_generation: Node

func _ready() -> void:
	image_generation.generation_started.connect(_cleanup_texture)
	image_generation.source_texture_updated.connect(_update_texture)
	
func _cleanup_texture():
	pass
	
func _update_texture():
	var individual_generator: IndividualGenerator = image_generation.individual_generator
	if texture == null:
		texture = RenderingCommon.create_texture_from_rd_rid(individual_generator.source_texture.rd_rid)
	else:
		RenderingCommon.texture_copy(
			individual_generator.source_texture.rd_rid,
			texture.texture_rd_rid,
			Renderer.rd,
			RenderingServer.get_rendering_device()
		)

		#var texture_rd_rid = _output_texture_rect.texture.texture_rd_rid
		#RenderingServer.get_rendering_device().free_rid(texture_rd_rid)
		#_output_texture_rect.texture = RenderingCommon.create_texture_from_rd_rid(renderer_texture.rd_rid)
