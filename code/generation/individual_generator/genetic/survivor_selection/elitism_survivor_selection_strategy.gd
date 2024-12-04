extends SurvivorSelectionStrategy

var _elitism_rate: float = 0.0

func select_survivors(
	parents: Array[Individual],
	children: Array[Individual]) -> Array[Individual]:
	
	# Amount of elite individuals that are kept
	var elite_parents_count = ceili(_elitism_rate * parents.size())
	
	# The amount of children that will survive
	var remaining_children_count = children.size() - elite_parents_count
	
	var generation: Array[Individual] = []
	
	# The parents array must be sorted in descending order
	generation.append_array(parents.slice(0, elite_parents_count))
	
	# Picks some children, its not necessary to sort them
	generation.append_array(children.slice(0, remaining_children_count))
	
	return generation

func set_params(params: SurvivorSelectionParams) -> void:
	_elitism_rate = params.elitisim_rate
