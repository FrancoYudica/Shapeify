## Subclasses implements a method that modifies individual properties
class_name IndividualAnimatorStrategy extends RefCounted

enum Type
{
	TIMELINE,
	TIMELINE_SCALE,
	TRANSLATE_TOP,
	SCALE_ALL,
	WAVE_FROM_LEFT
}

var viewport_size: Vector2i

## Animates the given individual with the normalized t parameter
## Returns if its visible.
func animate(
	individual: Individual, 
	index: int,
	count: int,
	t: float) -> bool:
	
	return false
