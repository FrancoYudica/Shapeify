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
	
	var render_scale = Globals.settings.render_scale
	
	var local_weight_texture = RendererTexture.load_from_texture(params.user_weight_texture)
	var scaled_texture = RenderingCommon.resize_texture(
		local_weight_texture,
		local_weight_texture.get_size() * render_scale
	)
	
	_weight_texture = scaled_texture
