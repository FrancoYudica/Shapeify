extends TexturePositionSampler

func sample() -> Vector2i:
	return Vector2i(
		randi_range(0, weight_texture.get_width() - 1),
		randi_range(0, weight_texture.get_height() - 1)
		)
