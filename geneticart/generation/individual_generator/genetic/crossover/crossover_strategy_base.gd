class_name CrossoverStrategy extends RefCounted

enum Type
{
	CLONE_PARENT_A,
	BLEND_MIDPOINT,
	BLEND_RANDOM,
	BLEND_BY_FITNESS
}

func crossover(
	parent_a: Individual,
	parent_b: Individual
) -> Individual:
	return null
