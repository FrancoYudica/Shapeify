class_name TexturePositionSampler extends RefCounted

enum Type
{
	RANDOM,
	WEIGHTED,
	LUMINEST
}

## Given a weight texture, a single pixel position is returned
func sample_position(weight_texture: RendererTexture) -> Vector2i:
	return Vector2.ZERO


static func factory_create(type: Type) -> TexturePositionSampler:
	match type:
		Type.RANDOM:
			return load("res://generation/texture_position_sampler/random_texture_position_sampler.gd").new()
		Type.WEIGHTED:
			return load("res://generation/texture_position_sampler/weighted_texture_position_sampler.gd").new()
		Type.LUMINEST:
			return load("res://generation/texture_position_sampler/luminest_pixel_texture_position_sampler.gd").new()
		_:
			push_error("Unimplemented factory_create type: %s" % type)
			return null
