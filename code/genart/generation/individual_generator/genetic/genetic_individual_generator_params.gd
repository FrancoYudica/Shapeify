class_name GeneticIndividualGeneratorParams extends Resource

@export var generation_count: int = 1:
	set(value):
		if value != generation_count:
			generation_count = value
			emit_changed()

@export var population_size: int = 50:
	set(value):
		if value != population_size:
			population_size = value
			emit_changed()

@export var fitness_calculator := FitnessCalculator.Type.MPA_RGB:
	set(value):
		if value != fitness_calculator:
			fitness_calculator = value
			emit_changed()

@export var mutation_rate: float = 0.05:
	set(value):
		if value != mutation_rate:
			mutation_rate = value
			emit_changed()

@export var mutation_factor: float = 1.0:
	set(value):
		if value != mutation_factor:
			mutation_factor = value
			emit_changed()

@export var selection_strategy := SelectionStrategy.Type.Ranking:
	set(value):
		if value != selection_strategy:
			selection_strategy = value
			emit_changed()

@export var crossover_strategy := CrossoverStrategy.Type.ATTRIBUTE_SPECIFIC_BLEND_RANDOM:
	set(value):
		if value != crossover_strategy:
			crossover_strategy = value
			emit_changed()

@export var mutation_strategy := MutationStrategy.Type.RANDOM:
	set(value):
		if value != mutation_strategy:
			mutation_strategy = value
			emit_changed()

@export var survivor_selection_strategy := SurvivorSelectionStrategy.Type.ELITISM:
	set(value):
		if value != survivor_selection_strategy:
			survivor_selection_strategy = value
			emit_changed()

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

func setup_changed_signals() -> void:
	survivor_selection_params.changed.connect(emit_changed)
