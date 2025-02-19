extends CrossoverStrategy

func crossover(
	parent_a: Individual,
	parent_b: Individual
) -> Individual:
	
	var child = Individual.new()
	
	# For each attribute there is a blending t
	var texture_t: float = randf()
	var position_t: float = randf()
	var size_t: float = randf()
	var rotation_t: float = randf()
	
	child.texture = parent_a.texture if randf() < texture_t else parent_b.texture
	
	# Lerps
	child.position = parent_a.position * position_t + parent_b.position * (1.0 - position_t)
	child.size = parent_a.size * size_t + parent_b.size * (1.0 - size_t)
	child.rotation = parent_a.rotation * rotation_t + parent_b.rotation * (1.0 - rotation_t)
	
	return child
