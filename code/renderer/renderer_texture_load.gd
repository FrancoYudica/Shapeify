## Exports the source texture and loads
class_name RendererTextureLoad extends RendererTexture

@export var _src_texture: Texture2D:
	set(texture):
		if texture != null:
			await Renderer.initialized
			rd_rid = RenderingCommon.create_local_rd_texture_copy(texture)
			_src_texture = null

func _notification(what: int) -> void:
	super._notification(what)
