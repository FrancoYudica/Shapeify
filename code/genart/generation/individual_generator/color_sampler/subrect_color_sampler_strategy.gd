extends ColorSamplerStrategy

var _individual_renderer: IndividualRenderer

var _sampler: AverageColorSampler

func _init() -> void:
	_individual_renderer = IndividualRenderer.new()
	_sampler = preload("res://generation/average_color_sampler/subrect/average_subrect_color_sampler.gd").new()
	
func set_sample_color(individual: Individual) -> void:
	individual.tint = _sampler.sample_rect(individual.get_bounding_rect())

func _sample_texture_set():
	_individual_renderer.source_texture = sample_texture
	_sampler.sample_texture = sample_texture
