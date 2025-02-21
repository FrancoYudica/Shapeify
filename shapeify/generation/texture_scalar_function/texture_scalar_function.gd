## Given a texture returns a single floating value
class_name TextureScalarFunction extends RefCounted

enum Type
{
	SUM,
	MAX,
	MIN
}

func evaluate(texture: RendererTexture) -> float:
	return 0.0


static func factory_create(type: Type) -> TextureScalarFunction:
	match type:
		Type.SUM:
			return load("res://generation/texture_scalar_function/sum_texture_scalar_function.gd").new()
		Type.MAX:
			return load("res://generation/texture_scalar_function/max_texture_scalar_function.gd").new()
		Type.MIN:
			return load("res://generation/texture_scalar_function/min_texture_scalar_function.gd").new()
		_:
			push_error("Unimplemented TextureScalarFunction type: %s" % type)
			return null
