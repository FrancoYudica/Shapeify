extends TexturePositionSampler

func sample_position(weight_texture: RendererTexture) -> Vector2i:
	var rd_rid = weight_texture.rd_rid
	var rd = Renderer.rd
	
	var texture_bytes = rd.texture_get_data(rd_rid, 0)
	var luminest_value: float = -1.0

	var width = weight_texture.get_width()
	var height = weight_texture.get_height()
	var pixel_count = width * height
	
	var luminance_array = Array()
	luminance_array.resize(pixel_count)
	
	var total_luminance = 0.0
	for i in range(pixel_count):
		var offset_index = i * 4
		var color = Color(
			texture_bytes[offset_index] / 255.0,
			texture_bytes[offset_index + 1] / 255.0,
			texture_bytes[offset_index + 2] / 255.0,
			texture_bytes[offset_index + 3] / 255.0
		)
		
		var luminance = color.get_luminance()
		total_luminance += luminance
		if luminance > luminest_value:
			luminest_value = luminance
		luminance_array[i] = luminance
	
	# Normalizes the luminance array
	var normalized_luminance_weights = luminance_array.map(
		func(luminance) -> float:
			return luminance / total_luminance
	)
	
	var weighted_sampler = WeightedRandomSampler.new()
	var selected_index = weighted_sampler.sample(normalized_luminance_weights)
	
	if selected_index == -1:
		# If no bright pixel is found, return (0,0) or another fallback
		return Vector2i(0, 0)

	# Correct conversion from 1D index to 2D coordinates
	var x = selected_index % width
	var y = selected_index / width

	return Vector2i(x, y)
