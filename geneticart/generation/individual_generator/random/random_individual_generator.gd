extends IndividualGenerator

func generate_individual(params: IndividualGeneratorParams) -> Individual:
	
	# Creates population
	var population: Array[Individual] = populator.generate_population(params.populator_params)
	
	# Samples the colors of all the individuals
	average_color_sampler.sample_texture = params.target_texture
	
	for individual in population:
		var individual_rect = individual.get_bounding_rect()
		var color = average_color_sampler.sample_rect(individual_rect)
		individual.tint = color
	
	# Calculates the fitness of all individuals
	error_metric.target_texture = params.target_texture
	
	# Queues all individuals for source texture rendering
	for individual in population:
		individual_src_texture_renderer.push_individual(individual)
		
		# When rendered
		individual_src_texture_renderer.individual_src_texture_rendered.connect(
			func (ind, individual_src_texture):
				ind.fitness = 1.0 - error_metric.compute(individual_src_texture)
		)
	
	# Starts rendering source textures
	individual_src_texture_renderer.source_texture = params.source_texture
	individual_src_texture_renderer.begin_rendering()
	
	# Waits until all textures where finished
	await individual_src_texture_renderer.finished_rendering
	
	# Ensures that all individuals have it's fitness set
	var all_fitness_set = false
	while not all_fitness_set:
		
		var fitness_set = true
		for individual in population:
			fitness_set = fitness_set and individual.fitness != -1
			
		all_fitness_set = fitness_set
	
	# Sorts population descending
	population.sort_custom(func(a, b): return a.fitness > b.fitness)
	
	# Returns the individual with highest fitness
	return population[0]
