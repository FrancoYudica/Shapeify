extends IndividualGenerator

func _generate() -> Individual:
	var individual := _populator.generate_one(params.populator_params)
	_fix_individual_properties(individual)
	
	_color_sampler_strategy.set_sample_color(individual)
	
	return individual
