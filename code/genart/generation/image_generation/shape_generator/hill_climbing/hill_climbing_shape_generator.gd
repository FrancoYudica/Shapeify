extends ShapeGenerator

var _fitness_calculator: FitnessCalculator
var _max_age: int = 0
func mutate(shape: Shape) -> void:
	var attribute_index: int = randi() % 4
	match attribute_index:
		0:
			shape.size.x *= randf_range(0.9, 1.1)
		1:
			shape.size.y *= randf_range(0.9, 1.1)
		2:
			shape.position.x += randf_range(-50, 50)
			shape.position.y += randf_range(-50, 50)
		3:
			shape.rotation = fmod(
				shape.rotation + randf_range(-PI * 0.25, PI * 0.25), 2 * PI
			)

func _generate() -> Shape:
	
	_fitness_calculator.weight_texture = weight_texture
	
	var shape = _populator.generate_one(params.populator_params)
	var individual = Individual.from_shape(shape)
	_fix_shape_attributes(individual)
	_color_sampler_strategy.set_sample_color(individual)
	_fitness_calculator.calculate_fitness(individual, source_texture)

	var age = 0
	while age < _max_age:
		
		# Copies the individual and mutates
		var new_individual = individual.copy()
		mutate(new_individual)
		
		# Sets attributes and calculates fitness
		_fix_shape_attributes(new_individual)
		_color_sampler_strategy.set_sample_color(new_individual)
		_fitness_calculator.calculate_fitness(new_individual, source_texture)
		if new_individual.fitness > individual.fitness:
			age = 0
			individual = new_individual
		else:
			age += 1
	
	return individual

func _setup():
	super._setup()
	var hill_climb_params := params.hill_climbing_params
	# Creates fitness calculator with factory
	_fitness_calculator = FitnessCalculator.factory_create(hill_climb_params.fitness_calculator)
	_fitness_calculator.target_texture = params.target_texture
	_max_age = hill_climb_params.max_age

func finished():
	_fitness_calculator = null
