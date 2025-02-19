extends ShapeSizeInitializer

func initialize_attribute(shape: Shape) -> void:
	shape.size.x = lerpf(1.0, 0.01, similarity)
	shape.size.y = lerpf(1.0, 0.01, similarity)
