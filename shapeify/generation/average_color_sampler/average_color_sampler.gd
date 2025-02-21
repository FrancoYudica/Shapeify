class_name AverageColorSampler extends RefCounted


## Texture sampled to get the colors
var sample_texture: RendererTexture:
	set(texture):
		
		if not texture.is_valid():
			printerr("Trying to assign invalid sample_texture to AverageColorSampler")
			return

		sample_texture = texture
		_sample_texture_set()

## Texture sampled to filter pixel by ID. This way, instead of sampling all the pixels contained
## in the sub-rect, only these with ID = 1.0 will be sampled.
var id_texture: RendererTexture:
	set(texture):
		
		if texture == null:
			id_texture = null
			return
		
		if not texture.is_valid():
			printerr("Trying to assign invalid id_texture to AverageColorSampler")
			return

		id_texture = texture
		_id_texture_set()


func sample_rect(rect: Rect2i) -> Color:
	return Color.BLACK

func _sample_texture_set():
	pass
	
func _id_texture_set():
	pass
