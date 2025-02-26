class_name DebugTextureHolder extends Node

@export var debug_signal_name: String
@export var texture_name: String
var _texture_rd: Texture2DRD
var _updated_texture: LocalTexture

var _mutex := Mutex.new()

func _ready() -> void:
	DebugSignals.connect(debug_signal_name, _update_texture_ref)

func _update_texture_ref(updated_texture: LocalTexture):
	_mutex.lock()
	_updated_texture = updated_texture
	_mutex.unlock()

func update_texture_rect(texture_rect: TextureRect):
	
	# Texture already updated or null
	if _updated_texture == null:
		return
	
	# Uses mutex since _update_texture_ref might gets called in another thread
	_mutex.lock()
	_texture_rd = _updated_texture.create_texture_2d_rd()
	texture_rect.texture = _texture_rd
	_updated_texture = null
	_mutex.unlock()
	
