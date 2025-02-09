extends Node

var weight_texture: Texture2DRD

func _ready() -> void:
	Globals.weight_texture_updated.connect(_copy_texture_contents)

func _exit_tree() -> void:
	_free_weight_texture()

func _copy_texture_contents(texture: RendererTexture):
	
	if texture == null:
		return
	
	# Copies weight texture
	if weight_texture != null:
		_free_weight_texture()
		
	weight_texture = RenderingCommon.create_texture_from_rd_rid(texture.rd_rid)

func _free_weight_texture():
	if weight_texture == null or not weight_texture.texture_rd_rid.is_valid():
		return
	
	var rd = RenderingServer.get_rendering_device()
	var texture_rd_rid = weight_texture.texture_rd_rid
	weight_texture.texture_rd_rid = RID()
	weight_texture = null
	rd.free_rid(texture_rd_rid)
