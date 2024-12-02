class_name GeneticIndividualGeneratorParams extends Resource

@export var generation_count: int = 1
@export var population_size: int = 50
@export var fitness_calculator: FitnessCalculator.Type = FitnessCalculator.Type.MPA_RGB
@export var mutation_rate: float = 0.05
@export var crossover_strategy: CrossoverStrategy.Type = CrossoverStrategy.Type.CLONE_PARENT_A
@export var mutation_strategy: MutationStrategy.Type = MutationStrategy.Type.DONT_MUTATE
