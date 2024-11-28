class_name AverageColorSampler extends RefCounted


var sample_texture: RendererTexture:
	set(texture):
		
		if not texture.is_valid():
			printerr("Trying to assign invalid sample_texture_rd_rid to AverageColorSampler")
			return

		sample_texture = texture
		_sample_texture_set()

func sample_rect(rect: Rect2i) -> Color:
	return Color.BLACK

func _sample_texture_set():
	pass
