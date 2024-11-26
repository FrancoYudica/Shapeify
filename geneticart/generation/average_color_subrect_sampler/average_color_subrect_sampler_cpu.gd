extends AverageColorSampler

var _sample_image: Image

func sample_rect(rect: Rect2i) -> Color:
	
	var accumulated_color = Color(0, 0, 0, 0)
	var sampled_count = 0
	for x in range(rect.position.x, rect.position.x + rect.size.x):
		
		
		# It's out of bounds and will always be
		if x < 0 or x >= _sample_image.get_width():
			continue
		
		for y in range(rect.position.y, rect.position.y + rect.size.y):
			
			# It's out of bounds and will always be
			if y < 0 or y >= _sample_image.get_height():
				continue
			
			var sample = _sample_image.get_pixel(x, y)
			accumulated_color += sample
			sampled_count += 1
			
	var avg_color = accumulated_color / sampled_count
			
	return avg_color
	

func _sample_texture_set():
	var texture_2d_rd = RenderingCommon.create_texture_from_rd_rid(sample_texture_rd_rid)
	_sample_image = texture_2d_rd.get_image()
	RenderingServer.get_rendering_device().free_rid(
		texture_2d_rd.texture_rd_rid
	)
