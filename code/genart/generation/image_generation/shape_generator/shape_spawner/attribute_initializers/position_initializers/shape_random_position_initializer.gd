extends ShapePositionInitializer

func initialize_attribute(shape: Shape) -> void:

	# Random position
	shape.position.x = randf()
	shape.position.y = randf()
