extends ColorSamplerStrategy

var _individual_renderer: IndividualRenderer

var _masked_sampler: AverageColorSampler

func _init() -> void:
	_individual_renderer = IndividualRenderer.new()
	_masked_sampler = preload("res://generation/average_color_sampler/masked/average_masked_color_sampler.gd").new()
	
func set_sample_color(individual: Individual) -> void:

	# Renders to get the ID texture
	_individual_renderer.render_individual(individual)
	
	# Gets masked avg color
	_masked_sampler.id_texture = _individual_renderer.get_id_attachment_texture()
	individual.tint = _masked_sampler.sample_rect(individual.get_bounding_rect())

func _sample_texture_set():
	_individual_renderer.source_texture = sample_texture
	_masked_sampler.sample_texture = sample_texture
