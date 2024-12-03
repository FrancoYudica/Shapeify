extends IndividualGenerator


func _generate() -> Individual:
	
	var total_color_time: float = 0.0
	var total_fitness_time: float = 0
	var total_render_time: float = 0
	var clock = Clock.new()
	# Creates population
	var population: Array[Individual] = populator.generate_population(
		params.best_of_random_params.individual_count, 
		params.populator_params)
	#clock.print_elapsed("Population created. ")
	clock.restart()
	
	# Queues all individuals for source texture rendering
	for individual in population:
		
		_fix_individual_properties(individual)
		clock.restart()
		color_sampler_strategy.set_sample_color(individual)
		total_color_time += clock.elapsed_ms()

		# Renders to get the individual source texture
		clock.restart()
		individual_renderer.render_individual(individual)
		total_render_time += clock.elapsed_ms()

		# Calculates fitness
		clock.restart()
		fitness_calculator.calculate_fitness(
			individual, 
			individual_renderer.get_color_attachment_texture())
		total_fitness_time += clock.elapsed_ms()
	
	#print("Total render time: %s" % total_render_time)
	#print("Total sample color time: %s" % total_color_time)
	#print("Total fitness time: %s" % total_fitness_time)

	# Sorts population descending
	population.sort_custom(func(a, b): return a.fitness > b.fitness)
	
	# Returns the individual with highest fitness
	return population[0]
