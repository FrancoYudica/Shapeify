extends ShapeSizeInitializer

var _texture_size: Vector2

func initialize_attribute(shape: Shape) -> void:
	shape.size.x = randf_range(8, _texture_size.x)
	shape.size.y = randf_range(8, _texture_size.y)

func update(
	target_texture: RendererTexture,
	source_texture: RendererTexture) -> void:
	_texture_size = target_texture.get_size()
