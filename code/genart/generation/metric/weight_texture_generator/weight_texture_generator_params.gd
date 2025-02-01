class_name WeightTextureGeneratorParams extends Resource

@export var weight_texture_generator_type := WeightTextureGenerator.Type.WHITE:
	set(value):
		if value != weight_texture_generator_type:
			weight_texture_generator_type = value
			emit_changed()

@export var user_weight_texture: RendererTexture:
	set(texture):
		user_weight_texture = texture
		emit_changed()
