extends IndividualGenerator


func _generate(params: IndividualGeneratorParams) -> Individual:
	
	var total_fitness_time: float = 0
	var total_render_time: float = 0
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
		
		# Renders
		var local_clock = Clock.new()
		individual_renderer.render_individual(individual)
		total_render_time += local_clock.elapsed_ms()
		
		# Calculates fitness
		local_clock.restart()
		var ind_texture_rd_id = individual_renderer.get_color_attachment_texture_rd_id()
		fitness_calculator.calculate_fitness_rd_id(individual, ind_texture_rd_id)
		total_fitness_time += local_clock.elapsed_ms()
	
	print("Total render time: %s" % total_render_time)
	print("Total fitness time: %s" % total_fitness_time)

	# Sorts population descending
	population.sort_custom(func(a, b): return a.fitness > b.fitness)
	
	# Returns the individual with highest fitness
	return population[0]
