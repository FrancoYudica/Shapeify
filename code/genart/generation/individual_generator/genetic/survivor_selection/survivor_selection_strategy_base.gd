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

static func factory_create(type: Type) -> SurvivorSelectionStrategy:
	match type:
		SurvivorSelectionStrategy.Type.KEEP_CHILDREN:
			return load("res://generation/individual_generator/genetic/survivor_selection/keep_children_survivor_selection_strategy.gd").new()
		SurvivorSelectionStrategy.Type.ELITISM:
			return load("res://generation/individual_generator/genetic/survivor_selection/elitism_survivor_selection_strategy.gd").new()
		SurvivorSelectionStrategy.Type.TOURNAMENT:
			return load("res://generation/individual_generator/genetic/survivor_selection/tournament_survivor_selection_strategy.gd").new()
		_:
			push_error("Survivor selection strategy %s not implemented" % Type.keys()[type])
			return null
