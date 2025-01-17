class_name IndividualAnimationPlayer extends RefCounted

var _animator_strategy: IndividualAnimatorStrategy

var animator := IndividualAnimatorStrategy.Type.TIMELINE:
	set(type):
		animator = type
		_animator_strategy = IndividualAnimatorStrategy.factory_create(type)

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
