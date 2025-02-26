## This position initializer uses the weight texture and the MPA fitness texture
## This method attempts to change the weight texture and decrease the weights
## where more progress is made, therefore focusing in areas of the image where
## less progress is made
extends ShapePositionInitializer

var _texture_position_sampler: TexturePositionSampler
var _mpa_image_processor: MPAImageProcessor
var _texture_multiply_image_processor: TextureMultiplyImageProcessor
var _max_texture_scalar_function: TextureScalarFunction
var _multiply_image_processor: MultiplyImageProcessor
var _blur: GaussianBlurImageProcessor
var _map_to_range: MapToRangeImageProcessor

var _probability_texture: LocalTexture

func initialize_attribute(shape: Shape) -> void:

	# Samples out of the texture position sampler
	var sampled_position = _texture_position_sampler.sample()
	shape.position.x = float(sampled_position.x) / _probability_texture.get_width()
	shape.position.y = float(sampled_position.y) / _probability_texture.get_height()

func update(
	target_texture: LocalTexture,
	source_texture: LocalTexture,
	weight_texture: LocalTexture) -> void:
	
	# Computes MPA texture -----------------------------------------------------
	_mpa_image_processor.src_texture = source_texture
	_mpa_image_processor.power = 6
	var mpa_texture = _mpa_image_processor.process_image(target_texture)
	
	# Blurs MPA texture --------------------------------------------------------
	_blur.sigma = 5
	var blurred_mpa = _blur.process_image(mpa_texture)
	
	# Normalizes blurred MPA ---------------------------------------------------
	var max_value = _max_texture_scalar_function.evaluate(blurred_mpa)
	_multiply_image_processor.multiply_value = 1.0 / max_value
	var normalized_mpa = _multiply_image_processor.process_image(blurred_mpa)

	# Maps both MPA and weight texture to non 0 range --------------------------
	# This is effective to avoid the dark spots generated by the weight texture
	_map_to_range.min_bound = 0.10
	_map_to_range.max_bound = 1.0
	var mapped_mpa = _map_to_range.process_image(normalized_mpa)
	_map_to_range.min_bound = 0.10
	_map_to_range.max_bound = 1.0
	var mapped_weight = _map_to_range.process_image(weight_texture)
	
	# Multiplies MPA and weihgts -----------------------------------------------
	# This generates some sort of `and` mask, focusing in the areas of the weight
	# texture, but also in the areas where the MPA error is larger
	_texture_multiply_image_processor.b_texture = mapped_mpa
	var raw_probabilities = _texture_multiply_image_processor.process_image(mapped_weight)
	
	# Normalizes the probabilities ---------------------------------------------
	max_value = _max_texture_scalar_function.evaluate(raw_probabilities)
	_multiply_image_processor.multiply_value = 1.0 / max_value
	_probability_texture = _multiply_image_processor.process_image(raw_probabilities)
	
	# Sets the probability texture to the weighted position sampler ------------
	_texture_position_sampler.weight_texture = _probability_texture
	DebugSignals.updated_spawn_position_probability_texture.emit(_probability_texture)
	
	
func set_params(params: ShapeSpawnerParams):
	_texture_position_sampler = TexturePositionSampler.factory_create(TexturePositionSampler.Type.WEIGHTED)
	_mpa_image_processor = ImageProcessor.factory_create(ImageProcessor.Type.MPA)
	_texture_multiply_image_processor = ImageProcessor.factory_create(ImageProcessor.Type.TEXTURE_MULTIPLY)
	_blur = ImageProcessor.factory_create(ImageProcessor.Type.GAUSSIAN_BLUR)
	_multiply_image_processor = ImageProcessor.factory_create(ImageProcessor.Type.MULTIPLY)
	_max_texture_scalar_function = TextureScalarFunction.factory_create(TextureScalarFunction.Type.MAX)
	_map_to_range = ImageProcessor.factory_create(ImageProcessor.Type.MAP_TO_RANGE)
