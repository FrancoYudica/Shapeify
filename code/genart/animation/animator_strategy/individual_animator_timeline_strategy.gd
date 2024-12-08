extends IndividualAnimatorStrategy


func animate(
	individual: Individual, 
	index: int,
	count: int,
	t: float) -> bool:
		
	var visible_count = floorf(count * t)
	return index < visible_count
