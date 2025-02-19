extends TexturePositionSampler

var _liminest_pixel: Vector2i

func sample() -> Vector2i:
	return _liminest_pixel

func _weight_texture_set():
	var rd_rid = weight_texture.rd_rid
	var rd = Renderer.rd
	var texture_bytes = rd.texture_get_data(rd_rid, 0)
	var texture_format = rd.texture_get_format(rd_rid)
	var luminest_value: float = -1.0
	var luminest_pixel_index: int = -1

	var width = weight_texture.get_width()
	var height = weight_texture.get_height()
	var pixel_count = width * height

	for i in range(pixel_count):
		var offset_index = i * 4
		var color = Color(
			texture_bytes[offset_index] / 255.0,
			texture_bytes[offset_index + 1] / 255.0,
			texture_bytes[offset_index + 2] / 255.0,
			texture_bytes[offset_index + 3] / 255.0
		)
		
		var luminance = color.get_luminance()
		if luminance > luminest_value:
			luminest_value = luminance
			luminest_pixel_index = i

	if luminest_pixel_index == -1:
		# If no bright pixel is found, return (0,0) or another fallback
		return Vector2i(0, 0)
	
	# Correct conversion from 1D index to 2D coordinates
	var x = luminest_pixel_index % width
	var y = luminest_pixel_index / width
	_liminest_pixel = Vector2i(x, y)
