class_name WeightedPopulatorParams extends Resource

@export var texture_position_sampler_type := TexturePositionSampler.Type.WEIGHTED:
	set(value):
		texture_position_sampler_type = value
		emit_changed()
