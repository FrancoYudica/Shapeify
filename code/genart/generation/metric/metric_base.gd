## The Metric class serves as the base class for all classes that implement 
## a method to calculate the error between two textures. Here, target_texture 
## refers to the reference texture, while source_texture is the texture whose 
## error is being calculated.
class_name Metric extends RefCounted

enum Type
{
	MPA_CEILab,
	MPA_RGB,
	MSE,
	DELTA_E_1976,
	DELTA_E_1994
}

var metric_name: String = "Metric base"

var target_texture: RendererTexture:
	set(texture):
		target_texture = texture
		_target_texture_set()

var weight_texture: RendererTexture:
	set(texture):
		
		if weight_texture != texture:
			weight_texture = texture
			_weight_texture_set()

func _target_texture_set():
	pass

func _weight_texture_set():
	pass


func compute(source_texture: RendererTexture) -> float:
	
	# Does validations
	if not target_texture.is_valid():
		printerr("target_texture must be valid in Metric.compute()")
		return -1.0

	if not source_texture.is_valid():
		printerr("target_texture must be valid in Metric.compute()")
		return -1.0
	
	
	if target_texture.get_size() != source_texture.get_size():
		printerr(
			"Metric at compute(): \"The target texture and source texture sizes mush match\". 
			target size: (%sx%spx). source size: (%sx%spx)" % 
			[
				target_texture.get_width(), 
				target_texture.get_height(), 
				source_texture.get_width(), 
				source_texture.get_height()
			])
		return -1.0
	
	# If no weight texture is set, a white texture is generated by default
	if weight_texture == null:
		var white_generator = WeightTextureGenerator.factory_create(WeightTextureGenerator.Type.WHITE)
		weight_texture = white_generator.generate(0.0, target_texture)
	
	return _compute(source_texture)
	
func _compute(source_texture: RendererTexture) -> float:
	return -1.0


static func factory_create(type: Type) -> Metric:
	match type:
		Type.MPA_CEILab:
			return load("res://generation/metric/mpa/mpa_CEILab_metric.gd").new()
		Type.MPA_RGB:
			return load("res://generation/metric/mpa/mpa_RGB_metric.gd").new()
		Type.MSE:
			return load("res://generation/metric/mse/mse_compute.gd").new()
		Type.DELTA_E_1976:
			return load("res://generation/metric/delta_e/delta_e_1976_mean.gd").new()
		Type.DELTA_E_1994:
			return load("res://generation/metric/delta_e/delta_e_1994_mean.gd").new()
		_:
			push_error("Unimplemented factory_create(type: %s)" % type)
			return null
