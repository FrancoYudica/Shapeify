extends Populator

func generate_one(params: PopulatorParams) -> Individual:
	var individual = Individual.new()
	individual.fitness = -1
	
	# Random position
	individual.position.x = randi_range(
		params.position_bound_min.x,
		params.position_bound_max.x)
	individual.position.y = randi_range(
		params.position_bound_min.y,
		params.position_bound_max.y)
		
	# Random texture
	individual.texture = params.textures.pick_random()
	
	# Random size
	individual.size.x = randf_range(
		params.size_bound_min.x,
		params.size_bound_max.x)
	individual.size.y = randf_range(
		params.size_bound_min.y,
		params.size_bound_max.y)
	# Random rotation
	individual.rotation = randf_range(0.0, 2.0 * PI)
	return individual
