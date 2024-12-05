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
