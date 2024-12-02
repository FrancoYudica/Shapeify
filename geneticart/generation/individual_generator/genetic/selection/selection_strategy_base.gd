class_name SelectionStrategy extends RefCounted

enum Type
{
	## The probabilities are calculated by the rank instead of it's fitness
	Ranking,
	
	## Also known as Roulette Wheel
	FitnessProportionate,
	
	## All have the same probability of being selected
	Uniform
}

## Given the population, returns a selection of the population of size `pool_size`
func select(population: Array[Individual], pool_size: int) -> Array[Individual]:
	return []
