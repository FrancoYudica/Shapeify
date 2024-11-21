## The ErrorMetric class serves as the base class for all classes that implement 
## a method to calculate the error between two textures. Here, target_texture 
## refers to the reference texture, while source_texture is the texture whose 
## error is being calculated.

class_name ErrorMetric extends Node

var target_texture: Texture2D = null:
	set(texture):
		target_texture = texture
		_set_target_texture(texture)

func _set_target_texture(texture):
	pass

func compute(source_texture: Texture2D) -> float:
	
	# Does validations
	if target_texture == null:
		printerr("target_texture can't be null in ErrorMetric.compute()")
		return -1.0

	if source_texture == null:
		printerr("target_texture can't be null in ErrorMetric.compute()")
		return -1.0

	if target_texture.get_size() != source_texture.get_size():
		printerr(
			"ErrorMetric at compute(): \"The target texture and source texture sizes mush match\". 
			target size: (%sx%spx). source size: (%sx%spx)" % 
			[
				target_texture.get_width(), 
				target_texture.get_height(), 
				source_texture.get_width(), 
				source_texture.get_height()])
		return -1.0
	
	return _compute(source_texture)
	
func _compute(source_texture):
	pass
