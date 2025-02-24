class_name WeightTextureGenerator extends RefCounted

enum Type
{
	WHITE,
	GAUSSIAN_SOBEL,
	SOBEL_GAUSSIAN,
	DIFFERENCE_OF_GAUSSIANS,
	MPA,
	USER
}

## Given the normalized progress and the source texture, `generate`
## returns a grayscale texture
func generate(
	progress: float,
	target_texture: LocalTexture,
	source_texture: LocalTexture) -> LocalTexture:
	return null

func set_params(params: WeightTextureGeneratorParams) -> void:
	pass

static func factory_create(type: Type) -> WeightTextureGenerator:
	match type:
		Type.WHITE:
			return load("res://generation/metric/weight_texture_generator/white_weight_texture_generator.gd").new()
		Type.GAUSSIAN_SOBEL:
			return load("res://generation/metric/weight_texture_generator/gaussian_sobel_weight_texture_generator.gd").new()
		Type.SOBEL_GAUSSIAN:
			return load("res://generation/metric/weight_texture_generator/sobel_gaussian_weight_texture_generator.gd").new()
		Type.DIFFERENCE_OF_GAUSSIANS:
			return load("res://generation/metric/weight_texture_generator/difference_of_gaussians_weight_texture_generator.gd").new()
		Type.MPA:
			return load("res://generation/metric/weight_texture_generator/mpa_weight_texture_generator.gd").new()
		Type.USER:
			return load("res://generation/metric/weight_texture_generator/user_weight_texture_generator.gd").new()
		_:
			push_error("Unimplemented factory create for type: %s" % type)
			return null
