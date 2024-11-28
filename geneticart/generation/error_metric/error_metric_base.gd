## The ErrorMetric class serves as the base class for all classes that implement 
## a method to calculate the error between two textures. Here, target_texture 
## refers to the reference texture, while source_texture is the texture whose 
## error is being calculated.
class_name ErrorMetric extends RefCounted

var target_texture: RendererTexture:
	set(texture):
		target_texture = texture
		_target_texture_set()

func _target_texture_set():
	pass

func compute(source_texture: RendererTexture) -> float:
	
	# Does validations
	if not target_texture.is_valid():
		printerr("target_texture must be valid in ErrorMetric.compute()")
		return -1.0

	if not source_texture.is_valid():
		printerr("target_texture must be valid in ErrorMetric.compute()")
		return -1.0
	
	
	if target_texture.get_size() != source_texture.get_size():
		printerr(
			"ErrorMetric at compute(): \"The target texture and source texture sizes mush match\". 
			target size: (%sx%spx). source size: (%sx%spx)" % 
			[
				target_texture.get_width(), 
				target_texture.get_height(), 
				source_texture.get_width(), 
				source_texture.get_height()
			])
		return -1.0
	
	return _compute(source_texture)
	
func _compute(source_texture: RendererTexture) -> float:
	return -1.0
