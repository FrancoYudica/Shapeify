extends IndividualAnimatorStrategy


func animate(
	individual: Individual, 
	index: int,
	count: int,
	t: float) -> bool:

	var uv = Vector2(
		float(individual.position.x) / viewport_size.x,
		float(individual.position.y) / viewport_size.y
	)
	
	var visible_count = count * t
	var fraction = (t * 2.0 - abs(1.0 - uv.y))

	#var visible_count = count * t
	#var fraction = (visible_count - index) * 0.25
	var v = clampf(fraction, 0.0, 1.0)
	v = sin(PI * 0.5 * v)
	
	var start_pos = Vector2(viewport_size.x, -individual.size.y) * 0.5
	var target_pos := Vector2(
		individual.position.x,
		individual.position.y
	)
	var current_pos = lerp(start_pos, target_pos, v)
	individual.position.x = int(current_pos.x)
	individual.position.y = int(current_pos.y)
	individual.size *= v
	
	return v > 0.0
