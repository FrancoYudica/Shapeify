## LocalTextureManager manages the rendering texture binding slots array and handles the creation of
## LocalTextures when a non-LocalTexture is used.
## Note that the renderer is primarily designed for image generation rather than as a generic 
## 2D renderer. This is why texture caching works in this project, though it might not be ideal. 
## Creating local textures is slow, especially if done multiple times per frame.
class_name LocalTextureManager extends RefCounted

# Set to 32 to ensure GPU bind compatibility
const _MAX_TEXTURES_SLOTS = 32

const _MAX_LOCAL_TEXTURES_CHACHED = 128

# Maps texture RD RID to LocalTexture
var _local_textures_map = {}

# Maps Texture2D RID to LocalTexture
var _cached_textures_map = {}

var rd: RenderingDevice

enum Status {
	FULL = -1
}

var texture_count:
	get:
		return _local_textures_map.size()

func get_local_texture(texture: Texture2D) -> LocalTexture:
	
	# Texture2D already a local texture, no need to create a new one
	if texture is LocalTexture:
		return texture
	
	# LocalTexture not created yet
	if not _cached_textures_map.has(texture.get_rid()):
		
		# Texture caching is full. This doesn't break the program but it shouldn't happen for performance reasons.
		if _cached_textures_map.size() == _MAX_LOCAL_TEXTURES_CHACHED:
			push_warning("TextureManager LocalTexture cache is full. Reaching this multiple times might decrease performance.")
			return null
		_cached_textures_map[texture.get_rid()] = LocalTexture.load_from_texture(texture, rd)
	
	# Returns the cached local texture
	return _cached_textures_map[texture.get_rid()]
	
	
func get_local_texture_slot(texture: LocalTexture) -> int:
	
	# When texture isn't added to the slots array
	if not _local_textures_map.has(texture.rd_rid):
		
		# Unable to add a new texture
		if _local_textures_map.size() == _MAX_TEXTURES_SLOTS:
			return Status.FULL
		
		_local_textures_map[texture.rd_rid] = texture
	
	return _get_texture_slot_index(texture.rd_rid)

func get_textures_rd_rid() -> Array:
	return _local_textures_map.values().map(
		func(texture: LocalTexture) -> RID:
			return texture.rd_rid
	)

func clear_cached_textures():
	_cached_textures_map.clear()

## Clear texture slots and frees textures from memory
func clear():
	_local_textures_map.clear()

func _get_texture_slot_index(id: RID) -> int:
	return _local_textures_map.keys().find(id)
