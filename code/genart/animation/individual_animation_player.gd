class_name IndividualAnimationPlayer extends RefCounted

var _animator_strategy: IndividualAnimatorStrategy

var animator := IndividualAnimatorStrategy.Type.TIMELINE:
	set(type):
		animator = type
		match(type):
			IndividualAnimatorStrategy.Type.TIMELINE:
				_animator_strategy = load("res://animation/animator_strategy/individual_animator_timeline_strategy.gd").new()
			IndividualAnimatorStrategy.Type.TIMELINE_SCALE:
				_animator_strategy = load("res://animation/animator_strategy/individual_animator_timeline_scale_strategy.gd").new()
			IndividualAnimatorStrategy.Type.TRANSLATE_TOP:
				_animator_strategy = load("res://animation/animator_strategy/individual_animator_translate_top_strategy.gd").new()
			IndividualAnimatorStrategy.Type.WAVE_FROM_LEFT:
				_animator_strategy = load("res://animation/animator_strategy/individual_animator_wave_from_left_strategy.gd").new()
			IndividualAnimatorStrategy.Type.SCALE_ALL:
				_animator_strategy = load("res://animation/animator_strategy/individual_animator_scale_all_strategy.gd").new()
			_:
				push_error("Unimplemented _animator_strategy type")

func animate(
	individuals: Array[Individual],
	viewport_size: Vector2i,
	t: float) -> Array[Individual]:
	
	_animator_strategy.viewport_size = viewport_size
	
	var copied: Array[Individual] = []
	for i in range(individuals.size()):
		var individual_copy = individuals[i].copy()
		var is_visible = _animator_strategy.animate(individual_copy, i, individuals.size(), t)
		if is_visible:
			copied.append(individual_copy)
		
	return copied


func _init() -> void:
	animator = IndividualAnimatorStrategy.Type.TIMELINE
