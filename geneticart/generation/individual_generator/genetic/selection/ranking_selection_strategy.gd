extends SelectionStrategy

func select(population: Array[Individual], pool_size: int) -> Array[Individual]:
	
	# Constructs the array of ranked probabilities and calculates total
	var rank_probabilities = []
	var total_probabilities = 0.0
	for i in range(population.size()):
		var prob = 1.0 / (i + 1.0)
		rank_probabilities.append(prob)
		total_probabilities += prob
	
	# Same as Proportionate Selection, but with ranked probabilities
	var cumulative_probabilities: Array[float] = []
	var cumulative_sum = 0.0
	for prob in rank_probabilities:
		cumulative_sum += prob
		cumulative_probabilities.append(cumulative_sum)
		
	var mating_pool: Array[Individual] = []
	
	while mating_pool.size() < pool_size:
	
		var rand_value = randf()
		
		for i in range(population.size()):
			var accumulated_prob = cumulative_probabilities[i]
			if rand_value <= accumulated_prob:
				mating_pool.append(population[i])
	
	return mating_pool
