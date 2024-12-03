extends VBoxContainer

@export var generations: SpinBox
@export var population_size: SpinBox
@export var mutation_rate: SpinBox
@export var fitness_option: OptionButton
@export var selection_option: OptionButton
@export var crossover_option: OptionButton
@export var mutation_option: OptionButton

@onready var _params = Globals \
						.settings \
						.image_generator_params \
						.individual_generator_params \
						.genetic_params
	
func _ready() -> void:
	
	# Generations spin ---------------------------------------------------------
	generations.value = _params.generation_count
	generations.value_changed.connect(
		func(v):
			_params.generation_count = v
	)
	
	# Population size spin -----------------------------------------------------
	population_size.value = _params.population_size
	population_size.value_changed.connect(
		func(v):
			_params.population_size = v
	)
	
	# Mutation rate spin -------------------------------------------------------
	mutation_rate.value = _params.mutation_rate
	mutation_rate.value_changed.connect(
		func(v):
			_params.mutation_rate = v
	)

	# Fitness option -----------------------------------------------------------
	for option in FitnessCalculator.Type.keys():
		fitness_option.add_item(option)
		
	fitness_option.select(_params.fitness_calculator)
	fitness_option.item_selected.connect(
		func(index):
			_params.fitness_calculator = index as FitnessCalculator.Type
	)
	
	# Selection option ---------------------------------------------------------
	for option in SelectionStrategy.Type.keys():
		selection_option.add_item(option)
		
	selection_option.select(_params.selection_strategy)
	selection_option.item_selected.connect(
		func(index):
			_params.selection_strategy = index as SelectionStrategy.Type
	)
	# Crossover option ---------------------------------------------------------
	for option in CrossoverStrategy.Type.keys():
		crossover_option.add_item(option)
		
	crossover_option.select(_params.crossover_strategy)
	crossover_option.item_selected.connect(
		func(index):
			_params.crossover_strategy = index as CrossoverStrategy.Type
	)

	# Mutation option ----------------------------------------------------------
	for option in MutationStrategy.Type.keys():
		mutation_option.add_item(option)
		
	mutation_option.select(_params.mutation_strategy)
	mutation_option.item_selected.connect(
		func(index):
			_params.mutation_strategy = index as MutationStrategy.Type
	)

func _process(dt) -> void:
	visible = Globals \
				.settings \
				.image_generator_params \
				.individual_generator_type == ImageGeneratorParams.IndividualGeneratorType.Genetic
