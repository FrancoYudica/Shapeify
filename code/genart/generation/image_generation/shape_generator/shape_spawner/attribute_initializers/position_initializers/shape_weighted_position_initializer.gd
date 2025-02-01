extends ShapePositionInitializer

var _texture_position_sampler: TexturePositionSampler
var _weight_texture_generator: WeightTextureGenerator

var _weight_texture: RendererTexture

func initialize_attribute(shape: Shape) -> void:

	# Samples out of the texture position sampler
	shape.position = _texture_position_sampler.sample()

func update(
	target_texture: RendererTexture,
	source_texture: RendererTexture) -> void:
	
	_weight_texture = _weight_texture_generator.generate(
		similarity,
		target_texture,
		source_texture)
		
	_texture_position_sampler.weight_texture = _weight_texture
	
func set_params(params: ShapeSpawnerParams):
	var position_params := params.shape_position_initializer_params
	_weight_texture_generator = WeightTextureGenerator.factory_create(position_params.weight_texture_generator_params.weight_texture_generator_type)
	_weight_texture_generator.set_params(position_params.weight_texture_generator_params)
	_texture_position_sampler = TexturePositionSampler.factory_create(TexturePositionSampler.Type.WEIGHTED)
