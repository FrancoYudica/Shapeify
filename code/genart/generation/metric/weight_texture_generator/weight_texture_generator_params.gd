class_name WeightTextureGeneratorParams extends Resource

@export var user_weight_texture: RendererTexture:
	set(texture):
		user_weight_texture = texture
		emit_changed()
