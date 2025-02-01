extends ShapePositionInitializer

var _texture_size: Vector2

func initialize_attribute(shape: Shape) -> void:

	# Random position
	shape.position.x = randi_range(0.0, _texture_size.x)
	shape.position.y = randi_range(0.0, _texture_size.y)

func update(
	target_texture: RendererTexture,
	source_texture: RendererTexture) -> void:
	_texture_size = target_texture.get_size()
