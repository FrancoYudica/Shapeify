extends ColorSamplerStrategy

var _shape_renderer: ShapeRenderer

var _sampler: AverageColorSampler

func _init() -> void:
	_shape_renderer = ShapeRenderer.new()
	_sampler = preload("res://generation/average_color_sampler/subrect/average_subrect_color_sampler.gd").new()
	
func set_sample_color(shape: Shape) -> void:
	shape.tint = _sampler.sample_rect(shape.get_bounding_rect())

func _sample_texture_set():
	_shape_renderer.source_texture = sample_texture
	_sampler.sample_texture = sample_texture
