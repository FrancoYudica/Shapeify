extends Populator

func generate_one(params: PopulatorParams) -> Shape:
	var shape = Shape.new()
	
	# Random position
	shape.position.x = randi_range(
		params.position_bound_min.x,
		params.position_bound_max.x)
	shape.position.y = randi_range(
		params.position_bound_min.y,
		params.position_bound_max.y)
		
	# Random texture
	shape.texture = params.textures.pick_random()
	
	# Random size
	shape.size.x = randf_range(
		params.size_bound_min.x,
		params.size_bound_max.x)
	shape.size.y = randf_range(
		params.size_bound_min.y,
		params.size_bound_max.y)
	# Random rotation
	shape.rotation = randf_range(0.0, 2.0 * PI)
	return shape
