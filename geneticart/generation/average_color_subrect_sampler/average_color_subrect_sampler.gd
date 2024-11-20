class_name AverageColorSampler extends Node


var sample_texture: Texture2D = null:
	set(texture):
		_set_sample_texture(texture)
		sample_texture = texture

func sample_rect(rect: Rect2i) -> Color:
		return Color.BLACK
		
func _set_sample_texture(texture):
	pass
