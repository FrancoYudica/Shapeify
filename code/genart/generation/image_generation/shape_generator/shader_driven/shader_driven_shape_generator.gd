extends ShapeGenerator


var _fitness_calculator: FitnessCalculator
var _max_age: int = 0
var _progress_metric: Metric
var _normalized_progress: float = 0.0

# Not all attributes have the same probability of getting chosen for mutation.
# Since position is sampled from the weight texture, it's considered mostly correct,
# so there is no need to fix that attribute that much.
# The same applies for the size, which decreases linearly.
# Rotation is the hardest attribute since it's purely random
var _attribute_mutation_cdf: PackedFloat32Array

func mutate(shape: Shape) -> void:
	var attribute_index: int = CDFSampler.sample_from_cdf(_attribute_mutation_cdf)
	match attribute_index:
		0:
			shape.position.x += randf_range(-shape.size.x * 0.25, shape.size.x * 0.25)
			shape.position.y += randf_range(-shape.size.y * 0.25, shape.size.y * 0.25)
		1:
			shape.size.x *= randf_range(0.9, 1.1)
			shape.size.y *= randf_range(0.9, 1.1)
		2:
			shape.rotation = fmod(
				shape.rotation + randf_range(-PI * 0.25, PI * 0.25), 2 * PI
			)

func _generate(similarity: float) -> Shape:

	 #Updates the weight texture of the fitness calculator
	_fitness_calculator.weight_texture = weight_texture
	var shape = _shape_spawner.spawn_one(similarity)
	
	var individual = Individual.from_shape(shape)
	
	_fix_shape_attributes(individual)
	_color_sampler_strategy.set_sample_color(individual)
	
	_fitness_calculator.calculate_fitness(individual, params.source_texture)

	var age = 0
	while age < _max_age:
		
		# Copies the individual and mutates
		var new_individual = individual.copy()
		mutate(new_individual)
		
		# Sets attributes and calculates fitness
		_fix_shape_attributes(new_individual)
		
		_color_sampler_strategy.set_sample_color(new_individual)
		_fitness_calculator.calculate_fitness(new_individual, params.source_texture)
		if new_individual.fitness > individual.fitness:
			age = 0
			individual = new_individual
		else:
			age += 1
	
	return individual

func _setup():
	super._setup()
	var shader_driven_params := params.shader_driven_params
	# Creates fitness calculator with factory
	_fitness_calculator = FitnessCalculator.factory_create(shader_driven_params.fitness_calculator)
	_fitness_calculator.target_texture = params.target_texture
	
	_max_age = shader_driven_params.max_age

	_progress_metric = Metric.factory_create(Metric.Type.DELTA_E_1976)
	_progress_metric.target_texture = params.target_texture
	
	# Rotation is more likely to mutate
	_attribute_mutation_cdf = CDFSampler.probabilities_to_cdf([1, 1, 2])

func finished():
	super.finished()
	_fitness_calculator = null
	_progress_metric = null
	
