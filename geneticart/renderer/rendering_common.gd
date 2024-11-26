class_name RenderingCommon extends Node

## Copies a TexureFormat
static func copy_texture_format(rd: RenderingDevice, texture_rd_id: RID) -> RDTextureFormat:
	var global_rd = RenderingServer.get_rendering_device()
	var src_format := global_rd.texture_get_format(texture_rd_id)
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
static func update_texture_diff_rd(
	src_texture: RID,
	dest_texture: RID,
	src_rd: RenderingDevice,
	dest_rd: RenderingDevice) -> void:
		
	var texture_data = src_rd.texture_get_data(src_texture, 0)
	var err = dest_rd.texture_update(dest_texture, 0, texture_data)
	
	if err != OK:
		printerr("Error while updating texture in update_texture_diff_rd()")

static func copy_texture_to_local_rd(
	texture: Texture, 
	rd: RenderingDevice,
	usage_bits = (
		RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT |
		RenderingDevice.TEXTURE_USAGE_STORAGE_BIT)
	):
	var texture_global_rd_id = RenderingServer.texture_get_rd_texture(texture.get_rid())
	var global_rd = RenderingServer.get_rendering_device()
	
	var tf = RenderingCommon.copy_texture_format(
		global_rd,
		texture_global_rd_id)
		
	tf.usage_bits = usage_bits
	var texture_data = global_rd.texture_get_data(texture_global_rd_id, 0)
	var texture_local_rd_id = rd.texture_create(
		tf,
		RDTextureView.new(),
		[texture_data])
		
	return texture_local_rd_id
