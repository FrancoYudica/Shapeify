extends ErrorMetric

var target_image: Image = null

func _set_target_texture(texture):
	target_image = texture.get_image()

## CPU calculation of Median Squared Error. 
func _compute(source_texture: Texture2D) -> float:
	
	var t = Time.get_ticks_msec()

	var source_image: Image = source_texture.get_image()
	
	# Term used to normalize the MSE
	var width = target_image.get_width()
	var height = target_image.get_height()
	
	# Calculates the sum of the squared differences
	var accumulated = 0.0
	for x in range(width):
		for y in range(height):
			var target_color = target_image.get_pixel(x, y)
			var source_color = source_image.get_pixel(x, y)
			var diff = target_color - source_color
			var squared_diffs = diff.r * diff.r + diff.g * diff.g + diff.b * diff.b
			accumulated += squared_diffs
			
	# Calculates MSE
	var num_channels = 3.0
	var n = 1.0 / (width * height * num_channels)
	var mse = accumulated * n
	
	return mse
