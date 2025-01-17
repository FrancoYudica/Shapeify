extends IndividualAnimatorStrategy


func animate(
	individual: Individual, 
	index: int,
	count: int,
	t: float) -> bool:
		
	# Rotates the individual one single time. Since t is normalized,
	# it will rotate in [0, 2PI], allowing a loop animation
	individual.rotation += t * 2.0 * PI
	return true
