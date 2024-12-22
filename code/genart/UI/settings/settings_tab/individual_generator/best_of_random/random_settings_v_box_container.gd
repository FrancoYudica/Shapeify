extends VBoxContainer

@export var individual_count: SpinBox
@export var fitness_option: OptionButton

var _params : BestOfRandomIndividualGeneratorParams:
	get:
		return Globals \
				.settings \
				.image_generator_params \
				.individual_generator_params \
				.best_of_random_params
	
func _ready() -> void:
	
	# Generations spin ---------------------------------------------------------
	individual_count.value_changed.connect(
		func(v):
			_params.individual_count = v
	)
	
	# Fitness option -----------------------------------------------------------
	for option in FitnessCalculator.Type.keys():
		fitness_option.add_item(option)
		
	fitness_option.item_selected.connect(
		func(index):
			_params.fitness_calculator = index as FitnessCalculator.Type
	)

	Globals.image_generator_params_updated.connect(_update)
	_update()
	
func _update():
	individual_count.value = _params.individual_count
	fitness_option.select(_params.fitness_calculator)

func _process(dt) -> void:
	visible = Globals \
				.settings \
				.image_generator_params \
				.individual_generator_type == IndividualGenerator.Type.BestOfRandom
