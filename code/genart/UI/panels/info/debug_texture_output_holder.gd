class_name DebugTextureHolder extends Node

@export var debug_signal_name: String
@export var texture_name: String
var texture: Texture2DRD

func _ready() -> void:
	DebugSignals.connect(debug_signal_name, _copy_texture_contents)

func _exit_tree() -> void:
	_free()

func _copy_texture_contents(updated_texture: RendererTexture):
	
	if updated_texture == null:
		return
	
	# Copies weight texture
	if texture != null:
		_free()
		
	texture = RenderingCommon.create_texture_from_rd_rid(updated_texture.rd_rid)

func _free():
	if texture == null or not texture.texture_rd_rid.is_valid():
		return
	
	var rd = RenderingServer.get_rendering_device()
	var texture_rd_rid = texture.texture_rd_rid
	texture.texture_rd_rid = RID()
	texture = null
	rd.free_rid(texture_rd_rid)
	
