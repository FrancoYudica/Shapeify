extends ShapeSizeInitializer

var _texture_size: Vector2

func initialize_attribute(shape: Shape) -> void:
	var r = randf() * 0.5
	var random_similarity = clampf(r + similarity, 0.0, 1.0)
	shape.size.x = _texture_size.x * lerpf(1.0, 0.01, random_similarity)
	shape.size.y = _texture_size.y * lerpf(1.0, 0.01, random_similarity)
	
func update(
	target_texture: RendererTexture,
	source_texture: RendererTexture) -> void:
	_texture_size = target_texture.get_size()
