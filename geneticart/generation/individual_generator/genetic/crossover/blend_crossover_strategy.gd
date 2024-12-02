extends CrossoverStrategy

func crossover(
	parent_a: Individual,
	parent_b: Individual
) -> Individual:
	
	var child = parent_a.copy()
	child.position = (parent_a.position + parent_b.position) * 0.5
	child.size = (parent_a.size + parent_b.size) * 0.5
	
	return child
