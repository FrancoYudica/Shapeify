extends SurvivorSelectionStrategy

var _tournament_size: int = 0

func select_survivors(
	parents: Array[Individual],
	children: Array[Individual]) -> Array[Individual]:
	
	var population: Array[Individual] = []
	population.append_array(parents)
	population.append_array(children)

	var generation: Array[Individual] = []
	
	while generation.size() < parents.size():
		
		# Builds tournament
		var tournament = []
		for i in _tournament_size:
			tournament.append(population.pick_random())
		
		# Picks the best
		var best: Individual = null
		for i in tournament:
			if best == null or i.fitness > best.fitness:
				best = i
		
		# Adds the best individual to the generation
		if generation.count(best) == 0:
			generation.append(best)
	
	return generation

func set_params(params: SurvivorSelectionParams) -> void:
	_tournament_size = params.tournament_size
