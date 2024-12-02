class_name FitnessCalculator extends RefCounted

enum Type
{
	CEILabMeanInvError,
	RGBMeanInvError,
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
