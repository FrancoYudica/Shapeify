class_name GeneticIndividualGeneratorParams extends Resource

@export var generation_count: int = 1
@export var population_size: int = 50
@export var fitness_calculator := FitnessCalculator.Type.MPA_RGB
@export var mutation_rate: float = 0.05
@export var mutation_factor: float = 1.0

@export var selection_strategy := SelectionStrategy.Type.Ranking
@export var crossover_strategy := CrossoverStrategy.Type.ATTRIBUTE_SPECIFIC_BLEND_RANDOM
@export var mutation_strategy := MutationStrategy.Type.RANDOM
@export var survivor_selection_strategy := SurvivorSelectionStrategy.Type.ELITISM

@export var survivor_selection_params := SurvivorSelectionParams.new()

func to_dict() -> Dictionary:
	return {
		"generation_count" : generation_count,
		"population_size" : population_size,
		"mutation_rate" : mutation_rate,
		"fitness_calculator": FitnessCalculator.Type.keys()[fitness_calculator],
		"selection_strategy": SelectionStrategy.Type.keys()[selection_strategy],
		"crossover_strategy": CrossoverStrategy.Type.keys()[crossover_strategy],
		"mutation_strategy": MutationStrategy.Type.keys()[mutation_strategy],
		"survivor_selection_strategy": SurvivorSelectionStrategy.Type.keys()[survivor_selection_strategy],
		"survivor_selection_strategy_params" : survivor_selection_params.to_dict()
	}
