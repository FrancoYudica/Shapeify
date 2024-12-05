extends IndividualGenerator

var _fitness_calculator: FitnessCalculator

func _generate() -> Individual:
	
	var total_color_time: float = 0.0
	var total_fitness_time: float = 0
	var total_render_time: float = 0
	var clock = Clock.new()
	# Creates population
	var population: Array[Individual] = _populator.generate_population(
		params.best_of_random_params.individual_count, 
		params.populator_params)
	#clock.print_elapsed("Population created. ")
	clock.restart()
	
	# Queues all individuals for source texture rendering
	for individual in population:
		
		_fix_individual_properties(individual)
		clock.restart()
		_color_sampler_strategy.set_sample_color(individual)
		total_color_time += clock.elapsed_ms()

		# Renders to get the individual source texture
		clock.restart()
		_individual_renderer.render_individual(individual)
		total_render_time += clock.elapsed_ms()

		# Calculates fitness
		clock.restart()
		_fitness_calculator.calculate_fitness(
			individual, 
			_individual_renderer.get_color_attachment_texture())
		total_fitness_time += clock.elapsed_ms()
	
	#print("Total render time: %s" % total_render_time)
	#print("Total sample color time: %s" % total_color_time)
	#print("Total fitness time: %s" % total_fitness_time)

	# Sorts population descending
	population.sort_custom(func(a, b): return a.fitness > b.fitness)
	
	# Returns the individual with highest fitness
	return population[0]


func _setup():
	super._setup()
	
	var best_of_random_params := params.best_of_random_params
	# Creates fitness calculator -----------------------------------------------
	match best_of_random_params.fitness_calculator:
		FitnessCalculator.Type.MPA_CEILab:
			_fitness_calculator = load("res://generation/individual/fitness_calculator/mpa_CEILab_fitness_calculator.gd").new()
		FitnessCalculator.Type.MPA_RGB:
			_fitness_calculator = load("res://generation/individual/fitness_calculator/mpa_RGB_fitness_calculator.gd").new()
		FitnessCalculator.Type.MSE:
			_fitness_calculator = load("res://generation/individual/fitness_calculator/mse_fitness_calculator_compute.gd").new()
		_:
			push_error("Unimplemented fitness calculator: %s" % best_of_random_params.fitness_calculator)
	
	_fitness_calculator.target_texture = params.target_texture
