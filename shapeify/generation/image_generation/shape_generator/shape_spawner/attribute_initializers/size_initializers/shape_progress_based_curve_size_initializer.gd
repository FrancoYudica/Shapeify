extends ShapeSizeInitializer

var _curve: Curve

func initialize_attribute(shape: Shape) -> void:
	var sampled = _curve.sample(similarity)
	shape.size.x = sampled + randf_range(-0.1, 0.1)
	shape.size.y = sampled + randf_range(-0.1, 0.1)

func set_params(params: ShapeSpawnerParams):
	_curve = params.shape_size_initializer_params.curve
