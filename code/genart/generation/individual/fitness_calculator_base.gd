class_name FitnessCalculator extends RefCounted

enum Type
{
	MPA_CEILab,
	MPA_RGB,
	MSE
}

var target_texture: RendererTexture:
	set(texture):
		
		if not texture.is_valid():
			printerr("Trying to assign invalid target_texture to fitness calculator")
			return
			
		target_texture = texture
		_target_texture_set()

func calculate_fitness(
	individual: Individual,
	source_texture: RendererTexture) -> void:
	
	individual.fitness = -1.0

func _target_texture_set():
	pass


static func factory_create(type: Type) -> FitnessCalculator:
	match type:
		FitnessCalculator.Type.MPA_CEILab:
			return load("res://generation/individual/fitness_calculator/mpa_CEILab_fitness_calculator.gd").new()
		FitnessCalculator.Type.MPA_RGB:
			return load("res://generation/individual/fitness_calculator/mpa_RGB_fitness_calculator.gd").new()
		FitnessCalculator.Type.MSE:
			return load("res://generation/individual/fitness_calculator/mse_fitness_calculator.gd").new()
		_:
			push_error("Unimplemented fitness calculator: %s" % type)
			return null
