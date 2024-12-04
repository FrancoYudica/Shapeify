## Generates the initial population of the algorithm
class_name Populator extends RefCounted

func generate_one(params: PopulatorParams) -> Individual:
	return null

func generate_population(
	size: int,
	params: PopulatorParams) -> Array[Individual]:
	
	var population: Array[Individual] = []

	for i in range(size):
		population.append(generate_one(params))
		
	return population
