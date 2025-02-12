extends WeightTextureGenerator

var _weight_texture: RendererTexture
var _map_to_range_image_processor: MapToRangeImageProcessor

func _init() -> void:
	_map_to_range_image_processor = ImageProcessor.factory_create(ImageProcessor.Type.MAP_TO_RANGE)
	_map_to_range_image_processor.min_bound = 0.1
	_map_to_range_image_processor.max_bound = 1.0

func generate(
	progress: float,
	target_texture: RendererTexture,
	source_texture: RendererTexture) -> RendererTexture:
	return _weight_texture

func set_params(params: WeightTextureGeneratorParams) -> void:
	
	if params.user_weight_texture == null:
		return
	
	var render_scale = Globals.settings.render_scale
	var scaled_texture = RenderingCommon.resize_texture(
		params.user_weight_texture,
		params.user_weight_texture.get_size() * render_scale
	)
	
	_weight_texture = scaled_texture
	
