class_name GeneticIndividualGeneratorParams extends Resource

@export var generation_count: int = 1
@export var population_size: int = 50
@export var fitness_calculator: FitnessCalculator.Type = FitnessCalculator.Type.MPA_RGB
@export var mutation_rate: float = 0.05

@export var selection_strategy: SelectionStrategy.Type = SelectionStrategy.Type.FitnessProportionate
@export var crossover_strategy: CrossoverStrategy.Type = CrossoverStrategy.Type.CLONE_PARENT_A
@export var mutation_strategy: MutationStrategy.Type = MutationStrategy.Type.DONT_MUTATE
@export var survivor_selection_strategy: SurvivorSelectionStrategy.Type = SurvivorSelectionStrategy.Type.KEEP_CHILDREN

@export var survivor_selection_params: SurvivorSelectionParams = SurvivorSelectionParams.new()
