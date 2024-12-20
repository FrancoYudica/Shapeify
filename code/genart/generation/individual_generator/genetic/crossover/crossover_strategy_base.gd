class_name CrossoverStrategy extends RefCounted

enum Type
{
	CLONE_PARENT_A,
	BLEND_MIDPOINT,
	PARENT_BLEND_RANDOM,
	ATTRIBUTE_SPECIFIC_BLEND_RANDOM,
	BLEND_BY_FITNESS
}

func crossover(
	parent_a: Individual,
	parent_b: Individual
) -> Individual:
	return null


static func factory_create(type: Type) -> CrossoverStrategy:
	match type:
		CrossoverStrategy.Type.CLONE_PARENT_A:
			return load("res://generation/individual_generator/genetic/crossover/clone_a_crossover_strategy.gd").new()
		CrossoverStrategy.Type.BLEND_MIDPOINT:
			return load("res://generation/individual_generator/genetic/crossover/blend_midpoint_crossover_strategy.gd").new()
		CrossoverStrategy.Type.PARENT_BLEND_RANDOM:
			return load("res://generation/individual_generator/genetic/crossover/parent_blend_random.gd").new()
		CrossoverStrategy.Type.ATTRIBUTE_SPECIFIC_BLEND_RANDOM:
			return load("res://generation/individual_generator/genetic/crossover/attribute_specific_blend_crossover.gd").new()
		CrossoverStrategy.Type.BLEND_BY_FITNESS:
			return load("res://generation/individual_generator/genetic/crossover/blend_by_fitness_crossover_strategy.gd").new()
		_:
			push_error("Crossover strategy %s not implemented" % Type.keys()[type])
			return null
