extends Node


## CPU calculation of Median Squared Error. 
func _on_difference_renderer_texture_rendered(texture: ViewportTexture) -> void:
	
	
	var image: Image = texture.get_image()
	var num_channels = 3.0
	
	# Term used to normalize the MSE
	var f = 1.0 / (image.get_width() * image.get_height() * num_channels)
	
	var mse = 0.0
	
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var color = image.get_pixel(x, y)
			var term = color.r * color.r + color.g * color.g + color.b * color.b
			mse += f * term
	
	print("MSE: %s" % mse)
