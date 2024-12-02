extends SelectionStrategy


func select(population: Array[Individual], pool_size: int) -> Array[Individual]:
	
	var total_fitness: float = 0.0
	for i in population:
		total_fitness += i.fitness
	
	# Calculates the cumulative probabilities of each individual. 
	# The accumulation of probabilities ensures that each individual's chance 
	# of being selected is proportional to its relative fitness, 
	# rather than being biased by its position in the array.
	var cumulative_probabilities: Array[float] = []
	var cumulative_sum = 0.0
	for i in population:
		cumulative_sum += i.fitness / total_fitness
		cumulative_probabilities.append(cumulative_sum)
	
	var mating_pool: Array[Individual] = []
	
	while mating_pool.size() < pool_size:
	
		var rand_value = randf()
		
		for i in range(population.size()):
			var accumulated_prob = cumulative_probabilities[i]
			if rand_value <= accumulated_prob:
				mating_pool.append(population[i])
	
	return mating_pool
