class_name AverageColorSampler extends Node


var sample_texture_rd_rid: RID:
	set(texture):
		
		if not texture.is_valid() or not Renderer.rd.texture_is_valid(texture):
			printerr("Trying to assign invalid sample_texture_rd_rid to AverageColorSampler")
			return

		sample_texture_rd_rid = texture
		_sample_texture_set()

func sample_rect(rect: Rect2i) -> Color:
	return Color.BLACK

func _sample_texture_set():
	pass
