## Texture2DRD that frees its contents from the GPU once all references are lost
## This avoids manually freeing textures
class_name AutoFreeTexture2DRD extends Texture2DRD

func _notification(what: int) -> void:
	# Frees texture when all references are lost
	if what == NOTIFICATION_PREDELETE:
		var rd = RenderingServer.get_rendering_device()
		if not rd == null and \
			rd != null and \
			rd.texture_is_valid(texture_rd_rid):
			rd.free_rid(texture_rd_rid)
