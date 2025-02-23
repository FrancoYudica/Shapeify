extends ShapeGenerator

var _crossover_strategy: CrossoverStrategy
var _mutation_strategy: MutationStrategy
var _selection_strategy: SelectionStrategy
var _survivor_selection_strategy: SurvivorSelectionStrategy
var _fitness_calculator: FitnessCalculator


func _generate(similarity: float) -> Shape:
	
	var genetic_params := params.genetic_params
	
	_fitness_calculator.weight_texture = weight_texture
	
	# Creates population
	var population: Array[Individual] = []
	for i in range(params.genetic_params.population_size):
		var shape = _shape_spawner.spawn_one(similarity)
		population.append(Individual.from_shape(shape))

	
	# Calculates the fitness of the individuals of initial population
	for individual in population:
		_fix_shape_attributes(individual)
		_color_sampler_strategy.set_sample_color(individual)
		_fitness_calculator.calculate_fitness(individual, source_texture)
		
	for generation in range(genetic_params.generation_count):
		
		Profiler.genetic_population_generated(population, source_texture)
		
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
			
			_fix_shape_attributes(child)
			_color_sampler_strategy.set_sample_color(child)
			_fitness_calculator.calculate_fitness(child, source_texture)
			children.append(child)
		
		population = _survivor_selection_strategy.select_survivors(
			population,
			children
		)
	
	# Returns the individual with highest fitness
	return population[0]
	
	

func _setup():
	super._setup()
	
	var genetic_params := params.genetic_params
	
	# Selection strategy factory
	_selection_strategy = SelectionStrategy.factory_create(genetic_params.selection_strategy)
	
	# Crossover factory
	_crossover_strategy = CrossoverStrategy.factory_create(genetic_params.crossover_strategy)
	
	# Mutation factory
	_mutation_strategy = MutationStrategy.factory_create(genetic_params.mutation_strategy)
	_mutation_strategy.set_params(genetic_params)
	
	# Survivor selection factory
	_survivor_selection_strategy = SurvivorSelectionStrategy.factory_create(genetic_params.survivor_selection_strategy)
	_survivor_selection_strategy.set_params(genetic_params.survivor_selection_params)
	
	# Fitness calculator factory
	_fitness_calculator = FitnessCalculator.factory_create(genetic_params.fitness_calculator)
	_fitness_calculator.target_texture = target_texture

func finished():
	super.finished()
	_selection_strategy = null
	_crossover_strategy = null
	_mutation_strategy = null
	_survivor_selection_strategy = null
	_fitness_calculator = null
	
