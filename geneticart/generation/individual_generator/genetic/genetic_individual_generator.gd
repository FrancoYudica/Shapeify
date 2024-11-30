extends IndividualGenerator

var _texture_size: Vector2

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

func _mutate(individual: Individual):
	individual.size.x *= randf_range(0.75, 1.5)
	individual.size.y = individual.size.x
	individual.position.x += randf_range(
		-_texture_size.x * 0.25,
		_texture_size.x * 0.25
	)
	individual.position.y += randf_range(
		-_texture_size.y * 0.25,
		_texture_size.y * 0.25
	)
	individual.position.x = clampi(individual.position.x, 0, _texture_size.x)
	individual.position.y = clampi(individual.position.y, 0, _texture_size.y)

func _generate() -> Individual:
	_texture_size = params.target_texture.get_size()
	
	var genetic_params := params.genetic_params
	
	# Creates initial population
	var population: Array[Individual] = populator.generate_population(params.populator_params)
	
	# Calculates the fitness of the individuals of initial population
	for individual in population:
		_calculate_individual_fitness(individual)
		
	for generation in range(genetic_params.generation_count):
	
		# Sorts population descending
		population.sort_custom(func(a, b): return a.fitness > b.fitness)
		
		var children: Array[Individual] = []
		
		for parent in population:
			var child = parent.copy()
			_mutate(child)
			children.append(child)
			_calculate_individual_fitness(child)
				
		population.append_array(children)
		population.sort_custom(func(a, b): return a.fitness > b.fitness)
		
		# Keeps the best individuals
		population = population.slice(0, params.populator_params.population_size)
	
	# Returns the individual with highest fitness
	return population[0]
