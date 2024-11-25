class_name TextureManager extends RefCounted

const _MAX_TEXTURES_SLOTS = 32
const _MAX_TEXTURES_CACHED = 128
var _textures: Dictionary
var _loaded_textures: Array[RID]
var rd: RenderingDevice

enum Status {
	FULL = -1,
	INVALID = -2
}

var texture_count:
	get:
		return _loaded_textures.size()


class _TextureData:
	var texture_rd_id: RID
	var use_count: int


func get_texture_slot_by_texture(texture: Texture) -> int:
	
	if texture == null:
		printerr("Unsuported texture null parameter")
		return Status.INVALID
	
	var texture_rid = texture.get_rid()

	# When texture isn't created
	if not _textures.has(texture_rid):
		
		# Unable to add a new texture
		if _textures.size() == _MAX_TEXTURES_SLOTS:
			return Status.FULL
		
		var rd_id = _create_texture(texture)
		if not rd_id.is_valid():
			return Status.INVALID
			
		_store_texture_rd_id(texture_rid, rd_id)
	
	# When texture isn't added to the slot
	_load_texture_to_slot(texture_rid)
	
	return _get_texture_slot_index(texture_rid)

func get_texture_slot_by_id(texture_rd_id: RID) -> int:
	
	# When texture isn't created
	if not _textures.has(texture_rd_id):
		
		# Unable to add a new texture
		if _textures.size() == _MAX_TEXTURES_SLOTS:
			return Status.FULL
		
		if not texture_rd_id.is_valid():
			return Status.INVALID
			
		_store_texture_rd_id(texture_rd_id, texture_rd_id)
	
	# When texture isn't added to the slot
	_load_texture_to_slot(texture_rd_id)
	
	return _get_texture_slot_index(texture_rd_id)

func get_texture_rd_id(id: RID):
	return _textures[id].texture_rd_id

func get_textures_rd_id() -> Array:
	return _loaded_textures

func clear_slots():
	_loaded_textures.clear()

## Clear texture slots and frees textures from memory
func clear():
	clear_slots()
	for texture_data in _textures:
		rd.free_rid(texture_data.texture_rd_id)
		
	_textures.clear()

func _load_texture_to_slot(id: RID):
	
	var texture_data = _textures[id]
	var texture_rd_id = texture_data.texture_rd_id
	
	# Already loaded
	if _loaded_textures.count(texture_rd_id) > 0:
		return
		
	_loaded_textures.append(texture_rd_id)

func _get_texture_slot_index(id: RID) -> int:
	return _loaded_textures.find(get_texture_rd_id(id))

func _store_texture_rd_id(
	id: RID, 
	texture_rd_id: RID):
	
	var texture_data = _TextureData.new()
	texture_data.texture_rd_id = texture_rd_id
	texture_data.use_count = 1
	_textures[id] = texture_data
	
	if _textures.size() >= _MAX_TEXTURES_CACHED:
		printerr("Texture manager is caching %s textures" % _textures.size())
	
	
func _create_texture(texture: Texture) -> RID:
	var texture_rd_id = RenderingServer.texture_get_rd_texture(texture.get_rid())
	
	# Texture is stored in global rendering device
	if texture_rd_id.is_valid():
		return RenderingCommon.copy_texture_to_local_rd(texture, rd)
	
	# Texture stored in local rendering device
	elif texture is Texture2DRD:
		return texture.texture_rd_rid
	
	return RID()
