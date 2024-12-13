extends TextureRect

@export var image_generation: Node

func _ready() -> void:
	image_generation.source_texture_updated.connect(_update_texture)
	image_generation.target_texture_updated.connect(_create_texture)
	
func _exit_tree() -> void:
	_free_texture()

func _create_texture():
	_free_texture()
	texture = RenderingCommon.create_texture_from_rd_rid(
		image_generation.image_generator.individual_generator.source_texture.rd_rid)


func _update_texture():
	
	if not Globals.settings.render_while_generating:
		return
	
	if texture == null:
		_create_texture()
	
	var individual_generator: IndividualGenerator = image_generation.image_generator.individual_generator
	RenderingCommon.texture_copy(
		individual_generator.source_texture.rd_rid,
		texture.texture_rd_rid,
		Renderer.rd,
		RenderingServer.get_rendering_device()
	)

func _free_texture():
	
	if texture == null:
		return
	
	var rd = RenderingServer.get_rendering_device()
	var texture_rd_rid = texture.texture_rd_rid
	texture.texture_rd_rid = RID()
	texture = null
	rd.free_rid(texture_rd_rid)
