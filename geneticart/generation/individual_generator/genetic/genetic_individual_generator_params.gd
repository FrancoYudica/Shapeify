class_name GeneticIndividualGeneratorParams extends Resource

@export var generation_count: int = 1
@export var population_size: int = 50
@export var fitness_calculator := FitnessCalculator.Type.MPA_RGB
@export var mutation_rate: float = 0.05

@export var selection_strategy := SelectionStrategy.Type.Ranking
@export var crossover_strategy := CrossoverStrategy.Type.ATTRIBUTE_SPECIFIC_BLEND_RANDOM
@export var mutation_strategy := MutationStrategy.Type.RANDOM
@export var survivor_selection_strategy := SurvivorSelectionStrategy.Type.ELITISM

@export var survivor_selection_params := SurvivorSelectionParams.new()
