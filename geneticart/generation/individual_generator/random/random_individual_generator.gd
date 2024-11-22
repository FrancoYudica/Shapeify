extends IndividualGenerator

func _generate(params: IndividualGeneratorParams) -> Individual:
	
	var clock = Clock.new()
	
	# Creates population
	var population: Array[Individual] = populator.generate_population(params.populator_params)
	clock.print_elapsed("Population created. ")
	clock.restart()
	
	# Samples the colors of all the individuals
	for individual in population:
		var individual_rect = individual.get_bounding_rect()
		var color = average_color_sampler.sample_rect(individual_rect)
		individual.tint = color
	clock.print_elapsed("Colors sampled. ")
	clock.restart()
	
	# Queues all individuals for source texture rendering
	for individual in population:
		individual_renderer.push_individual(individual)
		
	# Sets up the callback to handle individual source texture rendering
	individual_renderer.rendered.connect(
		func (ind, individual_src_texture):
			fitness_calculator.calculate_fitness(ind, individual_src_texture)
	)

	# Starts rendering source textures
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
	
	# Returns the individual with highest fitness
	return population[0]
