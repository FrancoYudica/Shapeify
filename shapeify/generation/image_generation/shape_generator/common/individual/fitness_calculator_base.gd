class_name FitnessCalculator extends RefCounted

enum Type
{
	MPA_CEILab,
	MPA_RGB,
	MPA_RGB_PARTIAL,
	MSE,
	DELTA_E_1976,
	DELTA_E_1994
}

var target_texture: LocalTexture:
	set(texture):
		
		if not texture.is_valid():
			printerr("Trying to assign invalid target_texture to fitness calculator")
			return
			
		target_texture = texture
		_target_texture_set()

var weight_texture: LocalTexture

var type: Type

## Given the individual and source texture (individual musn't be rendered on source_texture) 
## `calculate_fitness` sets the fitness to the individual. Note that fitness is a normalized value
## in range [0.0, 1.0]
func calculate_fitness(
	individual: Individual,
	source_texture: LocalTexture) -> void:
	
	individual.fitness = -1.0

func _target_texture_set():
	pass

static func factory_create(type: Type) -> FitnessCalculator:
	var strategy: FitnessCalculator = null
	match type:
		FitnessCalculator.Type.MPA_CEILab:
			strategy = load("res://generation/image_generation/shape_generator/common/individual/fitness_calculator/mpa_CEILab_fitness_calculator.gd").new()
		FitnessCalculator.Type.MPA_RGB:
			strategy = load("res://generation/image_generation/shape_generator/common/individual/fitness_calculator/mpa_RGB_fitness_calculator.gd").new()
		FitnessCalculator.Type.MPA_RGB_PARTIAL:
			strategy = load("res://generation/image_generation/shape_generator/common/individual/fitness_calculator/partial_mpa_RGB_fitness_calculator.gd").new()
		FitnessCalculator.Type.MSE:
			strategy = load("res://generation/image_generation/shape_generator/common/individual/fitness_calculator/mse_fitness_calculator.gd").new()
		FitnessCalculator.Type.DELTA_E_1976:
			strategy = load("res://generation/image_generation/shape_generator/common/individual/fitness_calculator/delta_e_1976_fitness_calculator.gd").new()
		FitnessCalculator.Type.DELTA_E_1994:
			strategy = load("res://generation/image_generation/shape_generator/common/individual/fitness_calculator/delta_e_1994_fitness_calculator.gd").new()
		_:
			push_error("Unimplemented fitness calculator: %s" % type)
			return null
		
	strategy.type = type
	return strategy
