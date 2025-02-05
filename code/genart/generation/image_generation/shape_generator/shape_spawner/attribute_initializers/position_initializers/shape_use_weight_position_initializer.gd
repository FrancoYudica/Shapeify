extends ShapePositionInitializer

var _texture_position_sampler: TexturePositionSampler

var _weight_texture: RendererTexture

func initialize_attribute(shape: Shape) -> void:

	# Samples out of the texture position sampler
	var sampled_position = _texture_position_sampler.sample()
	shape.position.x = float(sampled_position.x) / _weight_texture.get_width()
	shape.position.y = float(sampled_position.y) / _weight_texture.get_height()

func update(
	target_texture: RendererTexture,
	source_texture: RendererTexture,
	weight_texture: RendererTexture) -> void:
	_weight_texture = weight_texture
	_texture_position_sampler.weight_texture = _weight_texture
	
func set_params(params: ShapeSpawnerParams):
	_texture_position_sampler = TexturePositionSampler.factory_create(TexturePositionSampler.Type.WEIGHTED)
