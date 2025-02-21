extends Node2D

@export var source_texture: Texture2D

var _texture_rd_rid: RID

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	_texture_rd_rid = RenderingCommon.create_local_rd_texture_copy(source_texture)
	
	var texture = RendererTexture.new()
	texture.rd_rid = _texture_rd_rid
	
func _process(delta: float) -> void:
	print("Removed successfully?: %s " % not Renderer.rd.texture_is_valid(_texture_rd_rid))
