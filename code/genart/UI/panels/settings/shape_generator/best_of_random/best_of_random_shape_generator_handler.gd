extends Node

@export var shape_count_spin_box: SpinBox
@export var fitness_option: OptionButton

var _params : BestOfRandomShapeGeneratorParams:
	get:
		return Globals \
				.settings \
				.image_generator_params \
				.shape_generator_params \
				.best_of_random_params
	
func _ready() -> void:
	
	# Generations spin ---------------------------------------------------------
	shape_count_spin_box.value_changed.connect(
		func(v):
			_params.shape_count = v
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
	shape_count_spin_box.value = _params.shape_count
	fitness_option.select(_params.fitness_calculator)
