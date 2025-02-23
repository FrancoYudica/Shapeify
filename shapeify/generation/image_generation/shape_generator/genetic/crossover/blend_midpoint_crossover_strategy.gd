extends CrossoverStrategy

func crossover(
	parent_a: Individual,
	parent_b: Individual
) -> Individual:
	
	var child = Individual.new()
	
	# Midpoint blending
	var t: float = 0.5

	child.texture = parent_a.texture if randf() < t else parent_b.texture
	
	# Lerps
	child.position = (parent_a.position + parent_b.position) * t
	child.size = (parent_a.size + parent_b.size) * t
	child.rotation = (parent_a.rotation + parent_b.rotation) * t
	
	return child
