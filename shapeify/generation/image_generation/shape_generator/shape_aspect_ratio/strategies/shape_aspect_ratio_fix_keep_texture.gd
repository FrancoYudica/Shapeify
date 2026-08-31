extends ShapeAspectRatioFixer


func fix_size(
	shape: Shape,
	target_texture: Texture2D,
	params: ShapeAspectRatioFixParams):
	var target_aspect = float(target_texture.get_width()) / target_texture.get_height()
	var texture_aspect = float(shape.texture.get_height()) / shape.texture.get_width()
	shape.size.y = shape.size.x * target_aspect * texture_aspect
