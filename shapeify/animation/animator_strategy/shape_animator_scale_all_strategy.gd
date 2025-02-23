extends ShapeAnimatiorStrategy


func animate(
	shape: Shape, 
	index: int,
	count: int,
	t: float) -> bool:
	
	var fraction = (t - float(index) / count)
	var scale = clampf(fraction, 0.0, 1.0)
	scale = sin(PI * 0.5 * scale)
	shape.size *= scale
	return scale > 0.0
