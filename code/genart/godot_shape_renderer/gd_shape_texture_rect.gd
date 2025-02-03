extends TextureRect


func from_shape(shape: Shape, gd_texture: Texture2D, render_scale: float = 1.0):
	size = shape.size / render_scale
	position.x = shape.position.x / render_scale - size.x * 0.5
	position.y = shape.position.y / render_scale - size.y * 0.5
	pivot_offset.x = size.x * 0.5
	pivot_offset.y = size.y * 0.5
	rotation = shape.rotation
	texture = gd_texture
	self_modulate = shape.tint
