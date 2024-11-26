## Texture rect that renders the framebuffer attachments
extends TextureRect

@export var renderer_fb_attachment_type: Renderer.FramebufferAttachment:
	set(value):
		renderer_fb_attachment_type = value
		
		if Renderer.is_initialized:
			_create_texture()

var _texture_rd_rid: RID

func _enter_tree() -> void:
	Renderer.resized.connect(_create_texture)
	Renderer.rendered.connect(_update_texture)

func _update_texture() -> void:
	
	if not visible:
		return
	
	var attachment_rd_rid = Renderer.get_attachment_texture_rd_rid(renderer_fb_attachment_type)
	RenderingCommon.texture_copy(
		attachment_rd_rid,
		texture.texture_rd_rid,
		Renderer.rd,
		RenderingServer.get_rendering_device()
	)

func _create_texture() -> void:
	var attachment_rd_rid = Renderer.get_attachment_texture_rd_rid(renderer_fb_attachment_type)
	var texture_rd: Texture2DRD = RenderingCommon.create_texture_from_rd_rid(attachment_rd_rid)
	
	texture = texture_rd
	
	if _texture_rd_rid.is_valid():
		var global_rd = RenderingServer.get_rendering_device()
		global_rd.free_rid(_texture_rd_rid)
		
	_texture_rd_rid = texture_rd.texture_rd_rid
