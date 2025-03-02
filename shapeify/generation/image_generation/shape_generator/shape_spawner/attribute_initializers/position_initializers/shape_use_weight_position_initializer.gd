extends ShapePositionInitializer


var _texture_position_sampler: TexturePositionSampler
var _probability_texture: LocalTexture

var _texture_multiply_image_processor := TextureMultiplyImageProcessor.new()
var _max_texture_scalar_function := TextureScalarFunction.factory_create(TextureScalarFunction.Type.MAX)
var _multiply_image_processor := MultiplyImageProcessor.new()


func initialize_attribute(shape: Shape) -> void:

	# Samples out of the texture position sampler
	var sampled_position = _texture_position_sampler.sample()
	shape.position.x = float(sampled_position.x) / _probability_texture.get_width()
	shape.position.y = float(sampled_position.y) / _probability_texture.get_height()

func update(
	target_texture: LocalTexture,
	source_texture: LocalTexture,
	weight_texture: LocalTexture,
	mask_texture: LocalTexture) -> void:
	
	var raw_probabilities := weight_texture

	# Filters pixels by using the mask -----------------------------------------
	_texture_multiply_image_processor.b_texture = mask_texture
	var masked_probabilities = _texture_multiply_image_processor.process_image(raw_probabilities)
	
	# Normalizes the probabilities ---------------------------------------------
	var max_value = _max_texture_scalar_function.evaluate(masked_probabilities)
	_multiply_image_processor.multiply_value = 1.0 / max_value
	_probability_texture = _multiply_image_processor.process_image(masked_probabilities)

	_texture_position_sampler.weight_texture = _probability_texture
	DebugSignals.updated_spawn_position_probability_texture.emit(_probability_texture)

	
func set_params(params: ShapeSpawnerParams):
	_texture_position_sampler = TexturePositionSampler.factory_create(TexturePositionSampler.Type.WEIGHTED)
