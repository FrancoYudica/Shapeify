## RendererTexture is a Texture2D that holds a texture reference rendering device resource ID
## to a texture created with the local renderer. It also automatically frees the texture
## when all the references are lost.
class_name RendererTexture extends Texture2D

## Renderer's rendering device texture resource ID
var rd_rid: RID:
	set(id):
		
		if id == RID():
			rd_rid = id
			return
		
		if not id.is_valid() or not Renderer.rd.texture_is_valid(id):
			push_error("Trying to set invalid rd_rid to RendererTexture")
			return
		
		rd_rid = id
		
		# Stores size to avoid loading format
		var format = Renderer.rd.texture_get_format(rd_rid)
		_size = Vector2i(format.width, format.height)

var _size: Vector2i

static func load_from_texture(src: Texture2D) -> RendererTexture:
	var texture = RendererTexture.new()
	texture.rd_rid = RenderingCommon.create_local_rd_texture_copy(src)
	return texture

static func load_from_path(path: String) -> RendererTexture:
	var img = Image.load_from_file(path)
	var texture_img = ImageTexture.create_from_image(img)
	var texture = RendererTexture.new()
	texture.rd_rid = RenderingCommon.create_local_rd_texture_copy(texture_img)
	return texture


func copy() -> RendererTexture:
	var format = RenderingCommon.texture_format_copy(
		Renderer.rd,
		rd_rid)
	
	format.usage_bits |= RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT
	format.usage_bits |= RenderingDevice.TEXTURE_USAGE_CAN_COPY_TO_BIT
	
	var texture_data = Renderer.rd.texture_get_data(rd_rid, 0)
	var new_rd_rid = Renderer.rd.texture_create(
		format,
		RDTextureView.new(),
		[texture_data]
	)
	
	var new_texture := RendererTexture.new()
	new_texture.rd_rid = new_rd_rid
	return new_texture

func copy_empty() -> RendererTexture:
	var format = RenderingCommon.texture_format_copy(
		Renderer.rd,
		rd_rid)
	
	format.usage_bits |= RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT
	format.usage_bits |= RenderingDevice.TEXTURE_USAGE_CAN_COPY_TO_BIT
	
	var new_rd_rid = Renderer.rd.texture_create(
		format,
		RDTextureView.new(),
		[]
	)
	
	var new_texture := RendererTexture.new()
	new_texture.rd_rid = new_rd_rid
	return new_texture

func copy_contents(other: RendererTexture) -> void:
	var err = Renderer.rd.texture_copy(
		other.rd_rid,
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

func is_valid() -> bool:
	return rd_rid.is_valid() and Renderer.rd.texture_is_valid(rd_rid)


func _get_width() -> int:
	return _size.x

func _get_height() -> int:
	return _size.y


func _notification(what: int) -> void:
	# Frees texture when all references are lost
	if what == NOTIFICATION_PREDELETE and \
		not Renderer == null and \
		Renderer.rd != null and \
		Renderer.rd.texture_is_valid(rd_rid):
		Renderer.rd.free_rid(rd_rid)
