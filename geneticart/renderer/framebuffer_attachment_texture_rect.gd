## Texture rect that renders the framebuffer attachments
extends TextureRect

@export var renderer_fb_attachment_type: Renderer.FramebufferAttachment:
	set(value):
		renderer_fb_attachment_type = value
		
		if Renderer.is_initialized:
			_create_texture()

var _texture_rd_rid: RID = RID()

func _enter_tree() -> void:
	Renderer.resized.connect(_create_texture)
	Renderer.rendered.connect(_update_texture)

func _update_texture() -> void:
	
	if not visible:
		return
	
	var data = Renderer.get_attachment_data(renderer_fb_attachment_type)
	var rd = RenderingServer.get_rendering_device()
	rd.texture_update(_texture_rd_rid, 0, data)

func _create_texture() -> void:

	# Creates the texture with the global rendering device
	var rd = RenderingServer.get_rendering_device()

	if _texture_rd_rid.is_valid():
		rd.free_rid(_texture_rd_rid)
		_texture_rd_rid = RID()
	
	# Gets the format of the color attachment
	var format: RDTextureFormat = Renderer.get_attachment_format(renderer_fb_attachment_type)
	var texture_format := RDTextureFormat.new()
	texture_format.texture_type = format.texture_type
	texture_format.width = format.width
	texture_format.height = format.height
	texture_format.format = format.format
	texture_format.usage_bits = (
		RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT | 
		RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT |
		RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT)
	
	_texture_rd_rid = rd.texture_create(
		texture_format, 
		RDTextureView.new(), 
		[])
	texture.texture_rd_rid = _texture_rd_rid
