class_name CrossoverStrategy extends RefCounted

enum Type
{
	CLONE_PARENT_A,
	ALTERNATIVE
}


func crossover(
	parent_a: Individual,
	parent_b: Individual
) -> Individual:
	return parent_a.copy()
