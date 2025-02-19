extends ShapeGenerator

func _generate(similarity) -> Shape:
	var shape := _shape_spawner.spawn_one(similarity)
	_fix_shape_attributes(shape)
	_color_sampler_strategy.set_sample_color(shape)
	
	return shape
