## LocalTexture is a Texture2D that holds a texture reference rendering device resource ID
## to a texture created with the local renderer. It also automatically frees the texture
## when all the references are lost.
class_name LocalTexture extends Texture2D

## Renderer's rendering device texture resource ID
var rd: RenderingDevice
var rd_rid: RID
var _size := Vector2i(-1, -1)

static func _texture_format_copy(
	texture_rd_rid: RID,
	rendering_device: RenderingDevice
) -> RDTextureFormat:
	var src_format := rendering_device.texture_get_format(texture_rd_rid)
	var texture_format = RDTextureFormat.new() 
	texture_format.texture_type = src_format.texture_type
	texture_format.width = src_format.width
	texture_format.height = src_format.height
	texture_format.format = src_format.format
	texture_format.mipmaps = src_format.mipmaps
	texture_format.samples = src_format.samples
	texture_format.usage_bits = src_format.usage_bits
	texture_format.usage_bits |= RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT | \
							 RenderingDevice.TEXTURE_USAGE_STORAGE_BIT | \
							 RenderingDevice.TEXTURE_USAGE_CAN_COPY_TO_BIT | \
							 RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT | \
							 RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT
	return texture_format
	
func copy(rendering_device: RenderingDevice=null) -> LocalTexture:
	
	var new_rd = rendering_device if rendering_device != null else rd
	
	# Copies texture format
	var texture_format = _texture_format_copy(rd_rid, rd)
	var texture_data = rd.texture_get_data(rd_rid, 0)
	var new_rd_rid = new_rd.texture_create(
		texture_format,
		RDTextureView.new(),
		[texture_data]
	)
	
	var new_texture := LocalTexture.new()
	new_texture.rd_rid = new_rd_rid
	new_texture.rd = new_rd
	return new_texture

func create_texture_2d_rd() -> AutoFreeTexture2DRD:
	# Creates the texture with the global rendering device
	var global_rd = RenderingServer.get_rendering_device()
	
	# Gets the format of the color attachment
	var texture_format = _texture_format_copy(rd_rid, rd)
	
	var new_global_texture_rd_rid = global_rd.texture_create(
		texture_format, 
		RDTextureView.new(), 
		[])
	
	# When the rendering device isn't the same, loads texture data to CPU and then sends to GPU
	var texture_data = rd.texture_get_data(rd_rid, 0)
	var err = global_rd.texture_update(new_global_texture_rd_rid, 0, texture_data)
	if err != OK:
		push_error("Error while copying textures")
	
	var texture_rd = AutoFreeTexture2DRD.new()
	texture_rd.texture_rd_rid = new_global_texture_rd_rid
	return texture_rd

func copy_contents(src_texture: LocalTexture) -> void:
	
	if src_texture.get_width() != get_width() or src_texture.get_height() != get_height():
		push_error("Texture copy contents missmatch")
		return
	
	var err = OK
	
	# When the rendering device isn't the same, loads texture data to CPU and then sends to GPU
	if src_texture.rd != rd:
		var texture_data = src_texture.rd.texture_get_data(src_texture.rd_rid, 0)
		err = rd.texture_update(rd_rid, 0, texture_data)
		
	# Otherwise copies through GPU, which is way faster
	else:
		err = rd.texture_copy(
			src_texture.rd_rid,
			rd_rid,
			Vector3(0, 0, 0),
			Vector3(0, 0, 0),
			Vector3(_size.x, _size.y, 0),
			0,
			0,
			0, 
			0
		)
	
	if err != OK:
		push_error("Error while copying textures")
		

static func create_empty(
	format: RDTextureFormat,
	rendering_device: RenderingDevice
) -> LocalTexture:
	
	var new_rd_rid = rendering_device.texture_create(
		format,
		RDTextureView.new(),
		[]
	)
	
	var new_texture := LocalTexture.new()
	new_texture.rd_rid = new_rd_rid
	new_texture.rd = rendering_device
	return new_texture


static func load_from_texture(
	src_texture: Texture2D,
	rendering_device: RenderingDevice) -> LocalTexture:

	var texture_global_rd_rid = RenderingServer.texture_get_rd_texture(src_texture.get_rid())
	var global_rd = RenderingServer.get_rendering_device()
	var texture_format = _texture_format_copy(texture_global_rd_rid, global_rd)
	var texture_data = global_rd.texture_get_data(texture_global_rd_rid, 0)
	
	var texture = LocalTexture.new()
	var texture_rd = rendering_device if rendering_device != null else global_rd
	texture.rd_rid = texture_rd.texture_create(
		texture_format,
		RDTextureView.new(),
		[texture_data])
		
	texture.rd = texture_rd
	return texture

static func load_from_path(
	path: String,
	rendering_device: RenderingDevice) -> LocalTexture:
	var img = Image.load_from_file(path)

	if img == null:
		return null

	var texture_img = ImageTexture.create_from_image(img)
	
	if texture_img == null:
		return null
	
	return load_from_texture(texture_img, rendering_device)

static func load_from_image(
	image: Image,
	rendering_device: RenderingDevice) -> LocalTexture:
	
	var image_data = image.get_data()

	var texture_format = RDTextureFormat.new() 
	texture_format.texture_type = RenderingDevice.TEXTURE_TYPE_2D
	texture_format.width = image.get_width()
	texture_format.height = image.get_height()
	texture_format.format = RenderingDevice.DATA_FORMAT_R8G8B8A8_UNORM
	texture_format.usage_bits = RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT | \
							 RenderingDevice.TEXTURE_USAGE_STORAGE_BIT | \
							 RenderingDevice.TEXTURE_USAGE_CAN_COPY_TO_BIT | \
							 RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT
	
	var texture = LocalTexture.new()
	texture.rd_rid = rendering_device.texture_create(
		texture_format,
		RDTextureView.new(),
		[image_data])
		
	texture.rd = rendering_device
	return texture

func is_valid() -> bool:
	return rd_rid.is_valid() and rd.texture_is_valid(rd_rid)

func _get_width() -> int:
	_update_size()
	return _size.x

func _get_height() -> int:
	_update_size()
	return _size.y

func _update_size():
	if _size.x == -1:
		var format = rd.texture_get_format(rd_rid)
		_size.x = format.width
		_size.y = format.height

func _notification(what: int) -> void:
	# Frees texture when all references are lost
	if what == NOTIFICATION_PREDELETE and \
		not rd == null and \
		rd != null and \
		rd.texture_is_valid(rd_rid):
		rd.free_rid(rd_rid)
