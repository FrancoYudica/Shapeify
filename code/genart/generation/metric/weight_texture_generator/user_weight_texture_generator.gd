extends WeightTextureGenerator

var _weight_texture: RendererTexture


func generate(
	progress: float,
	target_texture: RendererTexture,
	source_texture: RendererTexture) -> RendererTexture:
	return _weight_texture

func set_params(params: WeightTextureGeneratorParams) -> void:
	
	if params.user_weight_texture == null:
		return
	
	var render_scale = Globals.settings.image_generator_params.render_scale
	_weight_texture = RenderingCommon.resize_texture(
		params.user_weight_texture,
		params.user_weight_texture.get_size() * render_scale
	)
	
