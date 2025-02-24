class_name LocalTextureManager extends RefCounted

const _MAX_TEXTURES_SLOTS = 32
var _loaded_textures: Array[LocalTexture]
var rd: RenderingDevice

enum Status {
	FULL = -1,
	INVALID = -2
}

var texture_count:
	get:
		return _loaded_textures.size()


func get_texture_slot(texture: LocalTexture) -> int:
	
	# When texture isn't created
	if not _has_texture(texture):
		
		# Unable to add a new texture
		if _loaded_textures.size() == _MAX_TEXTURES_SLOTS:
			return Status.FULL
		
		if not texture.is_valid():
			return Status.INVALID
		
		_loaded_textures.append(texture)
	
	return _get_texture_slot_index(texture.rd_rid)

func get_textures_rd_rid() -> Array:
	return _loaded_textures.map(
		func(texture: LocalTexture) -> RID:
			return texture.rd_rid
	)

func clear_slots():
	_loaded_textures.clear()

## Clear texture slots and frees textures from memory
func clear():
	_loaded_textures.clear()


func _has_texture(texture: LocalTexture) -> bool:
	for t in _loaded_textures:
		if t.rd_rid == texture.rd_rid:
			return true
			
	return false
		

func _get_texture_slot_index(id: RID) -> int:
	
	for i in range(_loaded_textures.size()):
		if _loaded_textures[i].rd_rid == id:
			return i
			
	return -1
