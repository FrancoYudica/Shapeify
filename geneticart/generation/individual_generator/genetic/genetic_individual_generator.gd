extends IndividualGenerator

var _texture_size: Vector2
var _crossover_strategy: CrossoverStrategy
var _mutation_strategy: MutationStrategy

func _calculate_individual_fitness(individual: Individual):

	# Renders to get the ID texture
	individual_renderer.render_individual(individual)
	
	# Gets masked avg color
	average_color_sampler.id_texture = individual_renderer.get_id_attachment_texture()
	individual.tint = average_color_sampler.sample_rect(individual.get_bounding_rect())
	
	# Renders to get the individual source texture
	individual_renderer.render_individual(individual)
	
	# Calculates fitness
	fitness_calculator.calculate_fitness(
		individual, 
		individual_renderer.get_color_attachment_texture())


func _generate() -> Individual:
	
	_initialize_components()
	
	var genetic_params := params.genetic_params
	
	# Creates initial population
	var population: Array[Individual] = populator.generate_population(
		genetic_params.population_size,
		params.populator_params)
	
	# Calculates the fitness of the individuals of initial population
	for individual in population:
		_fix_individual_properties(individual)
		_calculate_individual_fitness(individual)
		
	for generation in range(genetic_params.generation_count - 1):
	
		# Sorts population descending
		population.sort_custom(func(a, b): return a.fitness > b.fitness)
		
		var children: Array[Individual] = []
		for parent in population:
			var child = parent.copy()
			_mutation_strategy.mutate(child)
			_fix_individual_properties(child)
			children.append(child)
			_calculate_individual_fitness(child)
				
		population.append_array(children)
		population.sort_custom(func(a, b): return a.fitness > b.fitness)
		
		# Keeps the best individuals
		population = population.slice(0, genetic_params.population_size)
	
	# Returns the individual with highest fitness
	return population[0]
	
	

func _initialize_components():
	
	_texture_size = params.target_texture.get_size()
	var genetic_params := params.genetic_params
	
	# Creates crossover strategy -----------------------------------------------
	match genetic_params.crossover_strategy:
		CrossoverStrategy.Type.CLONE_PARENT_A:
			_crossover_strategy = load("res://generation/individual_generator/genetic/crossover/crossover_strategy_base.gd").new()
		_:
			push_error("Crossover strategy not implemented")
	
	# Creates mutation strategy ------------------------------------------------
	match genetic_params.mutation_strategy:
		MutationStrategy.Type.DONT_MUTATE:
			_mutation_strategy = load("res://generation/individual_generator/genetic/mutation/mutation_strategy_base.gd").new()
		MutationStrategy.Type.RANDOM:
			_mutation_strategy = load("res://generation/individual_generator/genetic/mutation/random_mutation_strategy.gd").new()
		_:
			push_error("Mutation strategy not implemented")

	# Creates fitness calculator -----------------------------------------------
	match genetic_params.fitness_calculator:
		FitnessCalculator.Type.MPA_CEILab:
			fitness_calculator = load("res://generation/individual/fitness_calculator/mpa_CEILab_fitness_calculator.gd").new()
		FitnessCalculator.Type.MPA_RGB:
			fitness_calculator = load("res://generation/individual/fitness_calculator/mpa_RGB_fitness_calculator.gd").new()
		FitnessCalculator.Type.MSE:
			fitness_calculator = load("res://generation/individual/fitness_calculator/mse_fitness_calculator_compute.gd").new()
		_:
			push_error("Unimplemented fitness calculator: %s" % genetic_params.fitness_calculator)
	
	fitness_calculator.target_texture = params.target_texture
