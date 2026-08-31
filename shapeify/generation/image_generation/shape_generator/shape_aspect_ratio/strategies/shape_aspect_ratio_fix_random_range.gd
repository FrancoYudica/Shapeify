extends ShapeAspectRatioFixer


func fix_size(
	shape: Shape,
	target_texture: Texture2D,
	params: ShapeAspectRatioFixParams):
	var aspect_ratio = randf_range(params.random_range_aspect_ratio_min, params.random_range_aspect_ratio_max)
	shape.size.y = shape.size.x / aspect_ratio
