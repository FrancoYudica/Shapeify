class_name ShapeAnimationPlayer extends RefCounted

var _animator_strategy: ShapeAnimatiorStrategy

var animator := ShapeAnimatiorStrategy.Type.TIMELINE:
	set(type):
		animator = type
		_animator_strategy = ShapeAnimatiorStrategy.factory_create(type)

func animate(
	shapes: Array[Shape],
	viewport_size: Vector2i,
	t: float) -> Array[Shape]:
	
	_animator_strategy.viewport_size = viewport_size
	
	var copied: Array[Shape] = []
	for i in range(shapes.size()):
		var shape_copy = shapes[i].copy()
		var is_visible = _animator_strategy.animate(shape_copy, i, shapes.size(), t)
		if is_visible:
			copied.append(shape_copy)
		
	return copied


func _init() -> void:
	animator = ShapeAnimatiorStrategy.Type.TIMELINE
