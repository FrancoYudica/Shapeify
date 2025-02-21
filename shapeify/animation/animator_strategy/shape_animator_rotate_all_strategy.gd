extends ShapeAnimatiorStrategy


func animate(
	shape: Shape, 
	index: int,
	count: int,
	t: float) -> bool:
		
	# Rotates the shape one single time. Since t is normalized,
	# it will rotate in [0, 2PI], allowing a loop animation
	shape.rotation += t * 2.0 * PI
	return true
