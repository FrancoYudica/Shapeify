extends TextureRect


func from_shape(shape: Shape, gd_texture: Texture2D, viewport_size: Vector2):
	size = shape.size * viewport_size
	position.x = shape.position.x * viewport_size.x - size.x * 0.5
	position.y = shape.position.y * viewport_size.y - size.y * 0.5
	pivot_offset.x = size.x * 0.5
	pivot_offset.y = size.y * 0.5
	rotation = shape.rotation
	texture = gd_texture
	self_modulate = shape.tint
