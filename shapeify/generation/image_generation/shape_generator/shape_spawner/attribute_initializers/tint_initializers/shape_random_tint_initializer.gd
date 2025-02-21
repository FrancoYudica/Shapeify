extends ShapeTintInitializer

func initialize_attribute(shape: Shape) -> void:
	shape.tint = Color(
		randf(),
		randf(),
		randf(),
		1.0
	)
