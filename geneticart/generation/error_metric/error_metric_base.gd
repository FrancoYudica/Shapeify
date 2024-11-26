## The ErrorMetric class serves as the base class for all classes that implement 
## a method to calculate the error between two textures. Here, target_texture 
## refers to the reference texture, while source_texture is the texture whose 
## error is being calculated.
class_name ErrorMetric extends Node

var target_texture_rd_rid: RID:
	set(texture):
		target_texture_rd_rid = texture
		_target_texture_set()

func _target_texture_set():
	pass

func compute(source_texture_rd_rid: RID) -> float:
	
	var target_format: RDTextureFormat = Renderer.rd.texture_get_format(target_texture_rd_rid)
	var src_format: RDTextureFormat = Renderer.rd.texture_get_format(source_texture_rd_rid)
	
	# Does validations
	if not target_texture_rd_rid.is_valid() or not Renderer.rd.texture_is_valid(target_texture_rd_rid):
		printerr("target_texture_rd_rid can't be null in ErrorMetric.compute_rd()")
		return -1.0

	if not source_texture_rd_rid.is_valid() or not Renderer.rd.texture_is_valid(source_texture_rd_rid):
		printerr("source_texture_rd_rid can't be null in ErrorMetric.compute_rd()")
		return -1.0
	
	
	if target_format.width != src_format.width or target_format.height != src_format.height:
		printerr(
			"ErrorMetric at compute(): \"The target texture and source texture sizes mush match\". 
			target size: (%sx%spx). source size: (%sx%spx)" % 
			[
				target_format.width, 
				target_format.height, 
				src_format.width, 
				src_format.height
			])
		return -1.0
	
	return _compute(source_texture_rd_rid)
	
func _compute(source_texture_rd_rid: RID) -> float:
	return -1.0
