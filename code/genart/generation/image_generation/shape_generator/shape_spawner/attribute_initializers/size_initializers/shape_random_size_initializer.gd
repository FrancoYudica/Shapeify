extends ShapeSizeInitializer

func initialize_attribute(shape: Shape) -> void:
	shape.size.x = randf_range(0.01, 1.0)
	shape.size.y = randf_range(0.01, 1.0)
