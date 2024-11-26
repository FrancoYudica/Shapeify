class_name RenderingCommon extends Node

## Copies a TexureFormat
static func texture_format_copy(
	rd: RenderingDevice, 
	texture_rd_id: RID) -> RDTextureFormat:
	var src_format := rd.texture_get_format(texture_rd_id)
	var texture_format = RDTextureFormat.new() 
	texture_format.texture_type = src_format.texture_type
	texture_format.width = src_format.width
	texture_format.height = src_format.height
	texture_format.format = src_format.format
	texture_format.mipmaps = src_format.mipmaps
	texture_format.samples = src_format.samples
	texture_format.usage_bits = src_format.usage_bits
	return texture_format

## Copies a texture that is in different rendering devices
static func texture_copy(
	src_texture: RID,
	dest_texture: RID,
	src_rd: RenderingDevice,
	dest_rd: RenderingDevice) -> void:
		
	var texture_data = src_rd.texture_get_data(src_texture, 0)
	var err = dest_rd.texture_update(dest_texture, 0, texture_data)
	
	if err != OK:
		printerr("Error while updating texture in texture_copy()")

## Given a Texture, create a local rendering device texture, that can be used by the renderer
## This function copies format and data
static func create_local_rd_texture_copy(
	src_texture: Texture,
	usage_bits: RenderingDevice.TextureUsageBits = (
		RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT |
		RenderingDevice.TEXTURE_USAGE_STORAGE_BIT)
	) -> RID:
	var texture_global_rd_id = RenderingServer.texture_get_rd_texture(
		src_texture.get_rid())
	
	var global_rd = RenderingServer.get_rendering_device()
	var texture_format = texture_format_copy(
		global_rd,
		texture_global_rd_id)
	
	texture_format.usage_bits = usage_bits
	var texture_data = global_rd.texture_get_data(texture_global_rd_id, 0)
	var texture_local_rd_id = Renderer.rd.texture_create(
		texture_format,
		RDTextureView.new(),
		[texture_data])
		
	return texture_local_rd_id

static func create_texture_from_rd_id(texture_rd_id: RID) -> Texture:
	# Creates the texture with the global rendering device
	var global_rd = RenderingServer.get_rendering_device()

	# Gets the format of the color attachment
	var texture_format = texture_format_copy(
		Renderer.rd, 
		texture_rd_id)
		
	texture_format.usage_bits |= (
		RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT | 
		RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT |
		RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT
	)
	
	var new_global_texture_rd_id = global_rd.texture_create(
		texture_format, 
		RDTextureView.new(), 
		[])
		
	var texture_rd = Texture2DRD.new()
	texture_rd.texture_rd_rid = new_global_texture_rd_id
	return texture_rd
