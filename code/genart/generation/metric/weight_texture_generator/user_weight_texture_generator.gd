extends WeightTextureGenerator

var _weight_texture: RendererTexture

func generate(
	progress: float,
	target_texture: RendererTexture) -> RendererTexture:
	return _weight_texture

func set_params(params: WeightTextureGeneratorParams) -> void:
	_weight_texture = params.user_weight_texture
