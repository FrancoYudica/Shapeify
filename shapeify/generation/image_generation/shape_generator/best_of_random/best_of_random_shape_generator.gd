extends ShapeGenerator

var _fitness_calculator: FitnessCalculator

func _generate(similarity: float) -> Shape:
	
	# Creates population
	var population: Array[Individual] = []
	for i in range(params.best_of_random_params.shape_count):
		var shape = _shape_spawner.spawn_one(similarity)
		population.append(Individual.from_shape(shape))
	
	_fitness_calculator.weight_texture = self.masked_weight_texture
	
	# Queues all individuals for source texture rendering
	for individual in population:
		
		_fix_shape_attributes(individual)
		_color_sampler_strategy.set_sample_color(individual)

		# Calculates fitness
		_fitness_calculator.calculate_fitness(individual, source_texture)
	
	# Sorts population descending
	population.sort_custom(func(a, b): return a.fitness > b.fitness)
	
	# Returns the individual with highest fitness
	return population[0]


func _setup():
	super._setup()
	var best_of_random_params := params.best_of_random_params
	# Creates fitness calculator with factory
	_fitness_calculator = FitnessCalculator.factory_create(best_of_random_params.fitness_calculator)
	_fitness_calculator.target_texture = target_texture

func finished():
	super.finished()
	_fitness_calculator = null
