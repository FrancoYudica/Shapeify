## Generates the initial population of the algorithm
class_name Populator extends RefCounted

func generate_one(params: PopulatorParams) -> Shape:
	return null

func generate_population(
	size: int,
	params: PopulatorParams) -> Array[Shape]:
	
	var population: Array[Shape] = []

	for i in range(size):
		population.append(generate_one(params))
		
	return population
