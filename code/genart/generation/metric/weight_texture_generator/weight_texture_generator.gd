class_name WeightTextureGenerator extends RefCounted

enum Type
{
	WHITE,
	GAUSSIAN_SOBEL,
	USER
}

## Given the normalized progress and the source texture, `generate`
## returns a grayscale texture
func generate(
	progress: float,
	target_texture: RendererTexture) -> RendererTexture:
	return null

func set_params(params: WeightTextureGeneratorParams) -> void:
	pass

static func factory_create(type: Type) -> WeightTextureGenerator:
	match type:
		Type.WHITE:
			return load("res://generation/metric/weight_texture_generator/white_weight_texture_generator.gd").new()
		Type.GAUSSIAN_SOBEL:
			return load("res://generation/metric/weight_texture_generator/gaussian_sobel_weight_texture_generator.gd").new()
		Type.USER:
			return load("res://generation/metric/weight_texture_generator/user_weight_texture_generator.gd").new()
		_:
			push_error("Unimplemented factory create for type: %s" % type)
			return null
