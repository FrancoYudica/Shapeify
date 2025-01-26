extends ShapeGenerator

func _generate() -> Shape:
	var shape := _populator.generate_one(params.populator_params)
	_fix_shape_attributes(shape)
	
	_color_sampler_strategy.set_sample_color(shape)
	
	return shape
