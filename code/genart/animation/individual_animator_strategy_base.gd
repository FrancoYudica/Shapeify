## Subclasses implements a method that modifies individual properties
class_name IndividualAnimatorStrategy extends RefCounted

enum Type
{
	TIMELINE,
	TIMELINE_SCALE,
	TRANSLATE_TOP,
	SCALE_ALL,
	ROTATE_ALL,
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
	

static func factory_create(type: Type) -> IndividualAnimatorStrategy:
	match(type):
		IndividualAnimatorStrategy.Type.TIMELINE:
			return load("res://animation/animator_strategy/individual_animator_timeline_strategy.gd").new()
		IndividualAnimatorStrategy.Type.TIMELINE_SCALE:
			return load("res://animation/animator_strategy/individual_animator_timeline_scale_strategy.gd").new()
		IndividualAnimatorStrategy.Type.TRANSLATE_TOP:
			return load("res://animation/animator_strategy/individual_animator_translate_top_strategy.gd").new()
		IndividualAnimatorStrategy.Type.WAVE_FROM_LEFT:
			return load("res://animation/animator_strategy/individual_animator_wave_from_left_strategy.gd").new()
		IndividualAnimatorStrategy.Type.SCALE_ALL:
			return load("res://animation/animator_strategy/individual_animator_scale_all_strategy.gd").new()
		IndividualAnimatorStrategy.Type.ROTATE_ALL:
			return load("res://animation/animator_strategy/individual_animator_rotate_all_strategy.gd").new()
		_:
			push_error("Unimplemented _animator_strategy type: %s" % type)
			return null
