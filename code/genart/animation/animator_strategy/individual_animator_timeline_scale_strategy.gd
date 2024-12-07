extends IndividualAnimatorStrategy


func animate(
	individual: Individual, 
	index: int,
	count: int,
	t: float) -> bool:
	
	var visible_count = count * t
	var fraction = visible_count - index
	var scale = clampf(fraction, 0.0, 1.0)
	scale = sin(PI * 0.5 * scale)
	individual.size *= scale
	return scale > 0.0
