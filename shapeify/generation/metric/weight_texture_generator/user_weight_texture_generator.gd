extends WeightTextureGenerator

var _weight_texture: LocalTexture

func generate(
	progress: float,
	target_texture: LocalTexture,
	source_texture: LocalTexture) -> LocalTexture:
	return _weight_texture

func set_params(params: WeightTextureGeneratorParams) -> void:
	
	if params.user_weight_texture == null:
		return
	
	var render_scale = Globals.settings.render_scale
	
	var local_weight_texture = LocalTexture.load_from_texture(
		params.user_weight_texture,
		GenerationGlobals.renderer.rd)
		
	var scaled_texture = RenderingCommon.resize_texture(
		GenerationGlobals.renderer,
		local_weight_texture,
		local_weight_texture.get_size() * render_scale
	)
	
	_weight_texture = scaled_texture
