## PartialMetric serves the same purpose as **Metric**, but it is optimized to calculate
## the metric within a specific subregion of the textures, thereby avoiding unnecessary computations.
## PartialMetric uses a shader that calculates the difference of the average metric withing a subrect
## then this difference is added to the metric value of the entire texture.
class_name PartialMetric extends RefCounted

var metric_name: String = "Metric base"

var target_texture: LocalTexture:
	set(texture):
		if texture != target_texture:
			target_texture = texture
			_target_texture_set()

var source_texture: LocalTexture:
	set(texture):
		
		if texture != source_texture:
			source_texture = texture
			_source_texture_set()

var new_source_texture: LocalTexture:
	set(texture):
		if texture != new_source_texture:
			new_source_texture = texture
			_new_source_texture_set()

var weight_texture: LocalTexture:
	set(texture):
		if texture != weight_texture:
			weight_texture = texture
			_weight_texture_set()

func _target_texture_set():
	pass

func _source_texture_set():
	pass

func _new_source_texture_set():
	pass
	
func _weight_texture_set():
	pass

func compute(subrect: Rect2i) -> float:
	
	# Does validations
	if not target_texture.is_valid():
		printerr("target_texture must be valid in Metric.compute()")
		return -1.0
	
	if not source_texture.is_valid():
		printerr("source_texture must be valid in Metric.compute()")
		return -1.0
	
	if not new_source_texture.is_valid():
		printerr("new_source_texture must be valid in Metric.compute()")
		return -1.0

	if not weight_texture.is_valid():
		printerr("new_source_texture must be valid in Metric.compute()")
		return -1.0

	if target_texture.get_size() != source_texture.get_size() \
		|| target_texture.get_size() != new_source_texture.get_size() \
		|| target_texture.get_size() != weight_texture.get_size():
		printerr("Texture sizes doesn't match")
		return -1.0
	
	return _compute(subrect)
	
func _compute(subrect: Rect2i) -> float:
	return -1.0
