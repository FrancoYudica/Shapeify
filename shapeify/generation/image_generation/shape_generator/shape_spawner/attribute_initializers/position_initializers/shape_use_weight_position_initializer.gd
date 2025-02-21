extends ShapePositionInitializer


var _texture_position_sampler: TexturePositionSampler

var _probability_texture: RendererTexture

func initialize_attribute(shape: Shape) -> void:

	# Samples out of the texture position sampler
	var sampled_position = _texture_position_sampler.sample()
	shape.position.x = float(sampled_position.x) / _probability_texture.get_width()
	shape.position.y = float(sampled_position.y) / _probability_texture.get_height()

func update(
	target_texture: RendererTexture,
	source_texture: RendererTexture,
	weight_texture: RendererTexture) -> void:
	_probability_texture = weight_texture
	_texture_position_sampler.weight_texture = _probability_texture
	DebugSignals.updated_spawn_position_probability_texture.emit(_probability_texture)

	
func set_params(params: ShapeSpawnerParams):
	_texture_position_sampler = TexturePositionSampler.factory_create(TexturePositionSampler.Type.WEIGHTED)
