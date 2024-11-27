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
	

func is_valid() -> bool:
	return rd_rid.is_valid() and Renderer.rd.texture_is_valid(rd_rid)


func _get_width() -> int:
	if not is_valid():
		return 0

	var format = Renderer.rd.texture_get_format(rd_rid)
	return format.width

func _get_height() -> int:
	
	if not is_valid():
		return 0
	
	var format = Renderer.rd.texture_get_format(rd_rid)
	return format.height


func _notification(what: int) -> void:
	# Frees texture when all references are lost
	if what == NOTIFICATION_PREDELETE and \
		Renderer.rd != null and \
		Renderer.rd.texture_is_valid(rd_rid):
			
		Renderer.rd.free_rid(rd_rid)
