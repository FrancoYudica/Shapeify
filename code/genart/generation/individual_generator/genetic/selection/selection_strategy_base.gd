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

static func factory_create(type: Type) -> SelectionStrategy:
	match type:
		SelectionStrategy.Type.Ranking:
			return load("res://generation/individual_generator/genetic/selection/ranking_selection_strategy.gd").new()
			
		SelectionStrategy.Type.FitnessProportionate:
			return load("res://generation/individual_generator/genetic/selection/fitness_proportionate_selection_strategy.gd").new()
			
		SelectionStrategy.Type.Uniform:
			return load("res://generation/individual_generator/genetic/selection/uniform_selection_strategy.gd").new()
		_:
			push_error("Selection strategy %s not implemented" % Type.keys()[type])
			return null
