class_name TextureManager extends RefCounted

const _MAX_TEXTURES_SLOTS = 32
const _MAX_TEXTURES_CACHED = 128
var _textures: Dictionary
var _loaded_textures_rd_rids: Array[RID]
var rd: RenderingDevice

enum Status {
	FULL = -1,
	INVALID = -2
}

var texture_count:
	get:
		return _loaded_textures_rd_rids.size()


class _TextureData:
	var texture: RendererTexture
	var use_count: int

func get_texture_slot(texture: RendererTexture) -> int:
	
	# When texture isn't created
	if not _textures.has(texture.rd_rid):
		
		# Unable to add a new texture
		if _textures.size() == _MAX_TEXTURES_SLOTS:
			return Status.FULL
		
		if not texture.is_valid():
			return Status.INVALID
			
		_store_texture_rd_rid(texture.rd_rid, texture)
	
	# When texture isn't added to the slot
	_load_texture_to_slot(texture)
	
	return _get_texture_slot_index(texture.rd_rid)

func get_texture_rd_rid(id: RID):
	return _textures[id].texture.rd_rid

func get_textures_rd_rid() -> Array:
	return _loaded_textures_rd_rids

func clear_slots():
	_loaded_textures_rd_rids.clear()

## Clear texture slots and frees textures from memory
func clear():
	clear_slots()
	for texture_data in _textures:
		rd.free_rid(texture_data.texture_rd_rid)
		
	_textures.clear()

func _load_texture_to_slot(texture: RendererTexture):
	
	var texture_data = _textures[texture.rd_rid]
	var texture_rd_rid = texture_data.texture.rd_rid
	
	# Already loaded
	if _loaded_textures_rd_rids.count(texture_rd_rid) > 0:
		return
		
	_loaded_textures_rd_rids.append(texture_rd_rid)

func _get_texture_slot_index(id: RID) -> int:
	return _loaded_textures_rd_rids.find(get_texture_rd_rid(id))

func _store_texture_rd_rid(
	id: RID, 
	texture: RendererTexture):
	
	var texture_data = _TextureData.new()
	texture_data.texture = texture
	texture_data.use_count = 1
	_textures[id] = texture_data
	
	if _textures.size() >= _MAX_TEXTURES_CACHED:
		printerr("Texture manager is caching %s textures" % _textures.size())
	
