extends ColorSamplerStrategy

var _sampler: AverageColorSampler

func _init() -> void:
	_sampler = preload("res://generation/average_color_sampler/subrect/average_subrect_color_sampler.gd").new()
	
func set_sample_color(shape: Shape) -> void:
	
	# Maps normalized bounding rect to canvas bounding rect
	var normalized_bounding_rect = shape.get_bounding_rect()
	var bounding_rect = Rect2i(
		normalized_bounding_rect.position.x * sample_texture.get_width(),
		normalized_bounding_rect.position.y * sample_texture.get_height(),
		normalized_bounding_rect.size.x * sample_texture.get_width(),
		normalized_bounding_rect.size.y * sample_texture.get_height()
	)
	
	# Samples
	shape.tint = _sampler.sample_rect(bounding_rect)

func _sample_texture_set():
	_sampler.sample_texture = sample_texture
