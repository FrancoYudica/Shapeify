extends VBoxContainer

@export var max_age: SpinBox
@export var fitness_option: OptionButton

var _params : ShaderDrivenShapeGeneratorParams:
	get:
		return Globals \
				.settings \
				.image_generator_params \
				.shape_generator_params \
				.shader_driven_params
	
func _ready() -> void:
	
	# Generations spin ---------------------------------------------------------
	max_age.value_changed.connect(
		func(v):
			_params.max_age = v
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
	max_age.value = _params.max_age
	fitness_option.select(_params.fitness_calculator)

func _process(dt) -> void:
	visible = Globals \
				.settings \
				.image_generator_params \
				.shape_generator_type == ShapeGenerator.Type.ShaderDriven
