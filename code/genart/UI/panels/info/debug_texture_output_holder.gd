class_name DebugTextureHolder extends Node

@export var debug_signal_name: String
@export var texture_name: String
var _texture_rd: Texture2DRD
var _updated_texture: RendererTexture

var _mutex := Mutex.new()

func _ready() -> void:
	DebugSignals.connect(debug_signal_name, _update_texture_ref)

func _exit_tree() -> void:
	_free()

func _update_texture_ref(updated_texture: RendererTexture):
	_mutex.lock()
	_updated_texture = updated_texture
	_mutex.unlock()

func update_texture_rect(texture_rect: TextureRect):
	
	# Texture already updated or null
	if _updated_texture == null:
		return
	
	# Uses mutex since _update_texture_ref might gets called in another thread
	_mutex.lock()
	_free()
	_texture_rd = RenderingCommon.create_texture_from_rd_rid(_updated_texture.rd_rid)
	texture_rect.texture = _texture_rd
	_updated_texture = null
	_mutex.unlock()
	

func _free():
	if _texture_rd == null or not _texture_rd.texture_rd_rid.is_valid():
		return
	
	var rd = RenderingServer.get_rendering_device()
	rd.free_rid(_texture_rd.texture_rd_rid)
