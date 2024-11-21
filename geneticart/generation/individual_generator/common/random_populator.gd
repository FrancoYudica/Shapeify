extends Populator

func generate_population(params: PopulatorParams) -> Array[Individual]:
	
	var population: Array[Individual] = []
	
	for i in range(params.population_size):
		var individual = Individual.new()
		
		# Random position
		individual.position.x = randi_range(
			params.position_bound_min.x,
			params.position_bound_max.x)
		individual.position.y = randi_range(
			params.position_bound_min.y,
			params.position_bound_max.y)
			
		# Random size
		individual.size.x = randf_range(
			params.size_bound_min.x,
			params.size_bound_max.x)
		individual.size.y = randf_range(
			params.size_bound_min.y,
			params.size_bound_max.y)
		
		# Random rotation
		individual.rotation = randf_range(0.0, 2.0 * PI)
		
		# Random texture
		individual.texture = params.textures.pick_random()
		
		population.append(individual)
		
	return population
