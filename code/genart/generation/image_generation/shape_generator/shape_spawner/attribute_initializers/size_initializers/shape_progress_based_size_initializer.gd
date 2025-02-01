extends ShapeSizeInitializer

var _texture_size: Vector2

func initialize_attribute(shape: Shape) -> void:
	shape.size.x = _texture_size.x * lerpf(1.0, 0.01, similarity)
	shape.size.y = _texture_size.y * lerpf(1.0, 0.01, similarity)

func update(
	target_texture: RendererTexture,
	source_texture: RendererTexture) -> void:
	_texture_size = target_texture.get_size()
