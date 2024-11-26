class_name FitnessCalculator extends Node

var target_texture_rd_rid: RID:
	set(texture):
		
		if not texture.is_valid() or not Renderer.rd.texture_is_valid(texture):
			printerr("Trying to assign invalid target_texture_rd_rid to fitness calculator")
			return
			
		target_texture_rd_rid = texture
		_target_texture_set()

func calculate_fitness(
	individual: Individual,
	source_texture_rd_rid: RID) -> void:
	
	individual.fitness = -1.0

func _target_texture_set():
	pass
