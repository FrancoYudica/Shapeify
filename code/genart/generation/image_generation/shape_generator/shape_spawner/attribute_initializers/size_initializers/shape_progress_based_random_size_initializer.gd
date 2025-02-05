extends ShapeSizeInitializer

func initialize_attribute(shape: Shape) -> void:
	var max_ratio = lerpf(1.0, 0.2, similarity)
	var min_ratio = .01
	
	shape.size.x = randf_range(min_ratio, max_ratio)
	shape.size.y = randf_range(min_ratio, max_ratio)
