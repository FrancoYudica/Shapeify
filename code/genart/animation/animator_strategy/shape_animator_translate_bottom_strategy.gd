extends ShapeAnimatiorStrategy

func animate(
	shape: Shape, 
	index: int,
	count: int,
	t: float) -> bool:

	# Calculates interpolatin factor -------------------------------------------
	var fraction = t * 2.0 - pow(shape.position.y, 2.0)

	var v = clampf(fraction, 0.0, 1.0)
	v = sin(PI * 0.5 * v)
	
	# Interpolates position and size -------------------------------------------
	var start_pos = Vector2(shape.position.x, 1.0 + shape.size.y * 0.5)
	var target_pos := Vector2(
		shape.position.x,
		shape.position.y
	)
	var current_pos = lerp(start_pos, target_pos, v)
	shape.position = current_pos
	shape.size *= v
	
	return v > 0.0
