extends ShapeRotationInitializer

func initialize_attribute(shape: Shape) -> void:
	shape.rotation = randf_range(0.0, 2.0 * PI)
