extends Populator

func generate_population(params: PopulatorParams) -> Array[Individual]:
	
	var population: Array[Individual] = []

	for i in range(params.population_size):
		var individual = Individual.new()
		individual.fitness = -1
		
		# Random position
		individual.position.x = randi_range(
			params.position_bound_min.x,
			params.position_bound_max.x)
		individual.position.y = randi_range(
			params.position_bound_min.y,
			params.position_bound_max.y)
			
		_set_size(params, individual)
		_set_rotation(params, individual)

		# Random texture
		individual.texture = params.textures.pick_random()
		
		population.append(individual)
		
	return population

func _set_size(
	params: PopulatorParams, 
	individual: Individual):
	
	individual.size.x = randf_range(
		params.size_bound_min.x,
		params.size_bound_max.x)
			
	if not params.box_size:
		individual.size.y = randf_range(
			params.size_bound_min.y,
			params.size_bound_max.y)
	else:
		individual.size.y = individual.size.x

func _set_rotation(
	params: PopulatorParams, 
	individual: Individual):
	individual.rotation = randf_range(0.0, 2.0 * PI) if params.random_rotation else 0.0
