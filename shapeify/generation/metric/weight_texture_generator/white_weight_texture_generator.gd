extends WeightTextureGenerator

func generate(
	progress: float,
	target_texture: LocalTexture,
	source_texture: LocalTexture) -> LocalTexture:
	
	var image = ImageUtils.create_monochromatic_image(
		target_texture.get_width(),
		target_texture.get_height(),
		Color.WHITE)
	
	var image_texture = ImageTexture.create_from_image(image)
	return LocalTexture.load_from_texture(image_texture, GenerationGlobals.renderer.rd)
