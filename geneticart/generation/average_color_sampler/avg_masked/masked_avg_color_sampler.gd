## Uses the Renderer's ID framebuffer attachment to filter pixels
class_name MaskedAverageColorSampler extends AverageColorSampler


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

	
func _id_texture_set():
	pass
