## Subclasses implements a method that modifies shape properties
class_name ShapeAnimatiorStrategy extends RefCounted

enum Type
{
	TIMELINE,
	TIMELINE_SCALE,
	TRANSLATE_TOP,
	SCALE_ALL,
	ROTATE_ALL,
	WAVE_FROM_LEFT
}


## Animates the given shape with the normalized t parameter
## Returns if its visible.
func animate(
	shape: Shape, 
	index: int,
	count: int,
	t: float) -> bool:
	
	return false
	

static func factory_create(type: Type) -> ShapeAnimatiorStrategy:
	match(type):
		ShapeAnimatiorStrategy.Type.TIMELINE:
			return load("res://animation/animator_strategy/shape_animator_timeline_strategy.gd").new()
		ShapeAnimatiorStrategy.Type.TIMELINE_SCALE:
			return load("res://animation/animator_strategy/shape_animator_timeline_scale_strategy.gd").new()
		ShapeAnimatiorStrategy.Type.TRANSLATE_TOP:
			return load("res://animation/animator_strategy/shape_animator_translate_top_strategy.gd").new()
		ShapeAnimatiorStrategy.Type.WAVE_FROM_LEFT:
			return load("res://animation/animator_strategy/shape_animator_wave_from_left_strategy.gd").new()
		ShapeAnimatiorStrategy.Type.SCALE_ALL:
			return load("res://animation/animator_strategy/shape_animator_scale_all_strategy.gd").new()
		ShapeAnimatiorStrategy.Type.ROTATE_ALL:
			return load("res://animation/animator_strategy/shape_animator_rotate_all_strategy.gd").new()
		_:
			push_error("Unimplemented _animator_strategy type: %s" % type)
			return null
