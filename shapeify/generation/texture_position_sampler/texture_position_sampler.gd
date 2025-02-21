class_name TexturePositionSampler extends RefCounted

enum Type
{
	RANDOM,
	WEIGHTED,
	LUMINEST
}

var weight_texture: RendererTexture:
	set(value):
		weight_texture = value
		_weight_texture_set()

## Given a weight texture, a single pixel position is returned
func sample() -> Vector2i:
	return Vector2.ZERO

func _weight_texture_set():
	pass


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
