extends MatingPoolStrategy



func create(sorted_population: Array[Individual]) -> Array[Individual]:
	
	var probabilities = []
	var n = sorted_population.size()
	for i in range(n):
		probabilities.append(1.0 / (i + 1.0))
	
	var selected_individuals: Array[Individual] = []
	
	while selected_individuals.size() < n:
		
		for i in range(n):
			var individual = sorted_population[i]
			var probability = probabilities[i]
			
			if randf() <= probability:
				selected_individuals.append(individual)
				
			if selected_individuals.size() == n:
				break
	
	return selected_individuals
