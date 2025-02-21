extends ShapeAnimatiorStrategy


var _rng := RandomNumberGenerator.new()

func animate(
	shape: Shape, 
	index: int,
	count: int,
	t: float) -> bool:

	# Computes interpolation factor --------------------------------------------
	var visible_count = count * t
	var remaining_count = count - visible_count
	
	# Since the shapes with larger index are visible later, the interpolation
	# time is smaller, making their animation faster
	var fraction = clampf((visible_count - index * 0.9) / remaining_count, 0.0, 1.0)
	
	# Maps to sin wave for smooth interpolation
	var interpolation_factor = sin(PI * 0.5 * fraction)

	# Interpolates position and size -------------------------------------------
	_rng.seed = index
	var start_pos = Vector2(_rng.randf(), _rng.randf())
	
	var target_pos := Vector2(
		shape.position.x,
		shape.position.y
	)
	var current_pos = lerp(start_pos, target_pos, interpolation_factor)
	shape.position = current_pos
	shape.size *= interpolation_factor
	
	return interpolation_factor > 0.0
