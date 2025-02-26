extends Node2D

@export var source_texture: Texture2D

var _texture_rd_rid: RID
var _rd: RenderingDevice

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_rd = RenderingServer.create_local_rendering_device()
	_texture_rd_rid = LocalTexture.load_from_texture(source_texture, _rd)
	
	var texture = LocalTexture.new()
	texture.rd_rid = _texture_rd_rid
	
func _process(delta: float) -> void:
	print("Removed successfully?: %s " % not _rd.texture_is_valid(_texture_rd_rid))
