extends ShapeAnimatiorStrategy


func animate(
	shape: Shape, 
	index: int,
	count: int,
	t: float) -> bool:

	var visible_count = floorf(count * t)
	return index < visible_count
