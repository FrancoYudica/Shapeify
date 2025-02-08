extends TextureRect

# Stores normalized attributes
var _shape_size: Vector2
var _shape_position: Vector2

func from_shape(shape: Shape, gd_texture: Texture2D):
	_shape_size = shape.size
	_shape_position = shape.position
	
	# Sets constant attributes
	rotation = shape.rotation
	texture = gd_texture
	self_modulate = shape.tint

func _process(_delta: float) -> void:
	
	# Updates position and size relative to viewport resolution
	var viewport_size = get_parent().size
	size = _shape_size * viewport_size
	position.x = _shape_position.x * viewport_size.x - size.x * 0.5
	position.y = _shape_position.y * viewport_size.y - size.y * 0.5
	pivot_offset.x = size.x * 0.5
	pivot_offset.y = size.y * 0.5
