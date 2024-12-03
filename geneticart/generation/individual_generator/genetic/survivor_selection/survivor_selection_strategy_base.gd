class_name SurvivorSelectionStrategy extends RefCounted

enum Type
{
	KEEP_CHILDREN,
	ELITISM,
	TOURNAMENT
}

func select_survivors(
	parents: Array[Individual],
	children: Array[Individual]) -> Array[Individual]:
	
	return []

func set_params(params: SurvivorSelectionParams) -> void:
	pass
