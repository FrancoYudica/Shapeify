class_name MutationStrategy extends RefCounted

enum Type
{
	DONT_MUTATE,
	RANDOM
}

func mutate(individual: Individual) -> void:
	return

func set_params(params: GeneticIndividualGeneratorParams) -> void:
	pass

static func factory_create(type: Type) -> MutationStrategy:
	match type:
		MutationStrategy.Type.DONT_MUTATE:
			return load("res://generation/individual_generator/genetic/mutation/mutation_strategy_base.gd").new()
		MutationStrategy.Type.RANDOM:
			return load("res://generation/individual_generator/genetic/mutation/random_mutation_strategy.gd").new()
		_:
			push_error("Mutation strategy %s not implemented" % Type.keys()[type])
			return null
