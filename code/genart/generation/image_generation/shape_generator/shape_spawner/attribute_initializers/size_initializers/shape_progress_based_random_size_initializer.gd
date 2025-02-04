extends ShapeSizeInitializer

var _texture_size: Vector2

func initialize_attribute(shape: Shape) -> void:
	var max_ratio = lerpf(1.0, 0.2, similarity)
	var max_size = _texture_size * max_ratio
	var min_size = Vector2(8.0, 8.0)
	
	shape.size.x = randf_range(min_size.x, max_size.x)
	shape.size.y = randf_range(min_size.y, max_size.y)
	
func update(
	target_texture: RendererTexture,
	source_texture: RendererTexture) -> void:
	_texture_size = target_texture.get_size()
