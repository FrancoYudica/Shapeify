extends IndividualGenerator

var _texture_size: Vector2
var _crossover_strategy: CrossoverStrategy
var _mutation_strategy: MutationStrategy
var _selection_strategy: SelectionStrategy
var _survivor_selection_strategy: SurvivorSelectionStrategy

func _calculate_individual_fitness(individual: Individual):
	_color_sampler_strategy.set_sample_color(individual)
	
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
		
		var mating_pool: Array[Individual] = _selection_strategy.select(
			population, 
			population.size())
		
		for i in range(population.size()):
			var parent_a = mating_pool.pick_random()
			var parent_b = mating_pool.pick_random()
			var child = _crossover_strategy.crossover(
				parent_a, 
				parent_b)
			
			if randf() <= genetic_params.mutation_rate:
				_mutation_strategy.mutate(child)
			
			_fix_individual_properties(child)
			_calculate_individual_fitness(child)
			children.append(child)
		
		population = _survivor_selection_strategy.select_survivors(
			population,
			children
		)
	
	# Returns the individual with highest fitness
	return population[0]
	
	

func _initialize_components():
	
	_texture_size = params.target_texture.get_size()
	var genetic_params := params.genetic_params

	# Creates selection strategy -----------------------------------------------
	match genetic_params.selection_strategy:
		SelectionStrategy.Type.Ranking:
			_selection_strategy = load("res://generation/individual_generator/genetic/selection/ranking_selection_strategy.gd").new()
			
		SelectionStrategy.Type.FitnessProportionate:
			_selection_strategy = load("res://generation/individual_generator/genetic/selection/fitness_proportionate_selection_strategy.gd").new()
			
		SelectionStrategy.Type.Uniform:
			_selection_strategy = load("res://generation/individual_generator/genetic/selection/uniform_selection_strategy.gd").new()
		_:
			push_error("Selection strategy not implemented")

	# Creates crossover strategy -----------------------------------------------
	match genetic_params.crossover_strategy:
		CrossoverStrategy.Type.CLONE_PARENT_A:
			_crossover_strategy = load("res://generation/individual_generator/genetic/crossover/clone_a_crossover_strategy.gd").new()
		CrossoverStrategy.Type.BLEND_MIDPOINT:
			_crossover_strategy = load("res://generation/individual_generator/genetic/crossover/blend_midpoint_crossover_strategy.gd").new()
		CrossoverStrategy.Type.PARENT_BLEND_RANDOM:
			_crossover_strategy = load("res://generation/individual_generator/genetic/crossover/parent_blend_random.gd").new()
		CrossoverStrategy.Type.ATTRIBUTE_SPECIFIC_BLEND_RANDOM:
			_crossover_strategy = load("res://generation/individual_generator/genetic/crossover/attribute_specific_blend_crossover.gd").new()
		CrossoverStrategy.Type.BLEND_BY_FITNESS:
			_crossover_strategy = load("res://generation/individual_generator/genetic/crossover/blend_by_fitness_crossover_strategy.gd").new()
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

	# Creates survivor selection strategy --------------------------------------
	match genetic_params.survivor_selection_strategy:
		SurvivorSelectionStrategy.Type.KEEP_CHILDREN:
			_survivor_selection_strategy = load("res://generation/individual_generator/genetic/survivor_selection/keep_children_survivor_selection_strategy.gd").new()
		SurvivorSelectionStrategy.Type.ELITISM:
			_survivor_selection_strategy = load("res://generation/individual_generator/genetic/survivor_selection/elitism_survivor_selection_strategy.gd").new()
		SurvivorSelectionStrategy.Type.TOURNAMENT:
			_survivor_selection_strategy = load("res://generation/individual_generator/genetic/survivor_selection/tournament_survivor_selection_strategy.gd").new()
		_:
			push_error("Survivor selection strategy not implemented")

	_survivor_selection_strategy.set_params(genetic_params.survivor_selection_params)

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
