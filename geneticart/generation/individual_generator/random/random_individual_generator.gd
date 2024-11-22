extends IndividualGenerator

func _generate(params: IndividualGeneratorParams) -> Individual:
	
	var clock = Clock.new()
	
	# Creates population
	var population: Array[Individual] = populator.generate_population(params.populator_params)
	clock.print_elapsed("Population created. ")
	clock.restart()
	# Samples the colors of all the individuals
	average_color_sampler.sample_texture = params.target_texture
	
	for individual in population:
		var individual_rect = individual.get_bounding_rect()
		var color = average_color_sampler.sample_rect(individual_rect)
		individual.tint = color
	clock.print_elapsed("Colors sampled. ")
	clock.restart()
	
	# Calculates the fitness of all individuals
	error_metric.target_texture = params.target_texture
	
	# Queues all individuals for source texture rendering
	for individual in population:
		individual_renderer.push_individual(individual)
		
	# Sets up the callback to handle individual source texture rendering
	individual_renderer.rendered.connect(
		func (ind, individual_src_texture):
			#clock.print_elapsed("Rendering done. ")
			ind.fitness = 1.0 - error_metric.compute(individual_src_texture)
			
	)

	# Starts rendering source textures
	individual_renderer.source_texture = params.source_texture
	
	var render_clock = Clock.new()
	individual_renderer.begin_rendering()
	
	# Waits until all textures where finished
	await individual_renderer.finished_rendering
	render_clock.print_elapsed("Finished rendering")
	# Ensures that all individuals have it's fitness set
	var all_fitness_set = false
	while not all_fitness_set:
		
		var fitness_set = true
		for individual in population:
			fitness_set = fitness_set and individual.fitness != -1
			
		all_fitness_set = fitness_set
	
	# Sorts population descending
	population.sort_custom(func(a, b): return a.fitness > b.fitness)
	print(population[0].fitness)
	print(population[population.size() - 1].fitness)
	# Returns the individual with highest fitness
	return population[0]
