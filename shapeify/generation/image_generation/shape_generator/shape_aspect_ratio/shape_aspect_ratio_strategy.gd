class_name ShapeAspectRatioFixer extends RefCounted

enum Type
{
	KeepTextureRatio,
	Random,
	RandomRange
}

func fix_size(
	shape: Shape,
	target_texture: Texture2D,
	params: ShapeAspectRatioFixParams):
	pass
	
static func factory_create(type: Type) -> ShapeAspectRatioFixer:
	match type:
		Type.KeepTextureRatio:
			return load("res://generation/image_generation/shape_generator/shape_aspect_ratio/strategies/shape_aspect_ratio_fix_keep_texture.gd").new()
		Type.Random:
			return load("res://generation/image_generation/shape_generator/shape_aspect_ratio/strategies/shape_aspect_ratio_fix_random.gd").new()
		Type.RandomRange:
			return load("res://generation/image_generation/shape_generator/shape_aspect_ratio/strategies/shape_aspect_ratio_fix_random_range.gd").new()
		_:
			return null
