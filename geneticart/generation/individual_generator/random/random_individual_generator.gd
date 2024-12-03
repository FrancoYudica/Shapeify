extends IndividualGenerator

func _generate() -> Individual:
	var individual := populator.generate_one(params.populator_params)
	_fix_individual_properties(individual)
	
	# Renders to get the ID texture
	individual_renderer.render_individual(individual)
	
	# Gets masked avg color
	average_color_sampler.id_texture = individual_renderer.get_id_attachment_texture()
	individual.tint = average_color_sampler.sample_rect(individual.get_bounding_rect())
	return individual
