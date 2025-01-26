extends ShapeAnimatiorStrategy


func animate(
	shape: Shape, 
	index: int,
	count: int,
	t: float) -> bool:
	
	var uv = Vector2(
		float(shape.position.x) / viewport_size.x,
		float(shape.position.y) / viewport_size.y
	)
	
	var visible_count = count * t
	var fraction = (t * 2.0 - uv.y)
	var v = clampf(fraction, 0.0, 1.0)
	v = sin(PI * 0.5 * v)
	
	var start_pos = Vector2(-shape.size.y, shape.position.y)
	var target_pos := Vector2(
		shape.position.x,
		shape.position.y
	)
	var current_pos = lerp(start_pos, target_pos, v)
	shape.position.x = int(current_pos.x)
	shape.position.y = int(current_pos.y)
	shape.size *= v
	
	return v > 0.0
