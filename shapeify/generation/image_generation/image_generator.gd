class_name ImageGenerator extends RefCounted

signal shape_generated(shape: Shape)
var params: ImageGeneratorParams

var shape_generator: ShapeGenerator

var _stop_mutex: Mutex = Mutex.new()
var _stop: bool = false
var _stop_condition: StopCondition

var _similarity_delta_e_metric: DeltaEMetric

var _generating: bool = false
var _weight_texture_generator: WeightTextureGenerator
var _user_mask_generator: UserMaskGenerator
var _multiply_textures_img_processor := TextureMultiplyImageProcessor.new()

var metric_value: float = 0.0
var similarity: float = 0.0

var weight_texture: LocalTexture
var user_mask_texture: LocalTexture
var target_texture: LocalTexture
var source_texture: LocalTexture

func stop():
	_stop_mutex.lock()
	_stop = true
	_stop_mutex.unlock()

func get_progress() -> float:
	if _stop_condition == null or not _generating:
		return 0.0
	return _stop_condition.get_progress()

func generate_image(first_src_texture: LocalTexture) -> LocalTexture:
	
	Profiler.image_generation_began(params)
	
	setup(first_src_texture)
	
	_generating = true
	_stop_condition.began_generating()
	var iteration = 0
	while not _stop_condition.should_stop():
		# Checks if the algorithm should stop executing
		_stop_mutex.lock()
		if _stop:
			_stop_mutex.unlock()
			break
		_stop_mutex.unlock()
		
		
		# Generates weight texture every X shapes
		if iteration % params.textures_update_interval == 0:
			weight_texture = _weight_texture_generator.generate(
				similarity,
				target_texture,
				source_texture)
			
			user_mask_texture = _user_mask_generator.generate_mask(
				params.user_mask_params.points,
				target_texture.get_size())
			
			# Updates the shape spawner
			shape_generator.update_spawner(similarity, weight_texture, user_mask_texture)
			
			#_multiply_textures_img_processor.b_texture = user_mask_texture
			#weight_texture = _multiply_textures_img_processor.process_image(weight_texture)
			
			DebugSignals.updated_weight_texture.emit(weight_texture)
			DebugSignals.updated_user_mask_texture.emit(user_mask_texture)
			
		# Computes the similarity between the target and source texture
		_compute_similarity()

		if weight_texture == null:
			Notifier.call_deferred("notify_error", "Weight texture is null. Ensure a weight texture is specified")
			break
		
		if weight_texture.get_size() != target_texture.get_size():
			Notifier.call_deferred("notify_error", ("Weight texture doesn't match target texture resolution. Weight(%sx%s) Target(%sx%s)" % [weight_texture.get_width(), weight_texture.get_height(), target_texture.get_width(), target_texture.get_height()]))
			break
		
		shape_generator.weight_texture = weight_texture
		shape_generator.mask_texture = user_mask_texture
		
		# Generates Shape
		var shape: Shape = shape_generator.generate_shape(similarity)
		# Renders the shape onto the source texture
		var renderer := GenerationGlobals.renderer
		ShapeRenderer.render_shape(
			renderer,
			source_texture,
			shape)
		var color_attachment = renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.COLOR)
		source_texture.copy_contents(color_attachment)
		
		shape_generated.emit(shape)
		_stop_condition.shape_generated(
			source_texture,
			target_texture,
			shape)
			
		iteration += 1
	
	shape_generator.finished()
	Profiler.image_generation_finished(source_texture)
	_generating = false
	return source_texture

func setup(first_source_texture: LocalTexture):
	_stop = false
	
	target_texture = LocalTexture.load_from_texture(params.target_texture, GenerationGlobals.algorithm_rd)
	
	# Setup stop condition -----------------------------------------------------
	_stop_condition = StopCondition.factory_create(params.stop_condition)
	_stop_condition.set_params(params.stop_condition_params)
	
	# Resizes target ans source texture ----------------------------------------
	var render_size = Globals.settings.render_scale * params.target_texture.get_size()
	target_texture = target_texture.get_resized(GenerationGlobals.renderer, render_size)
	source_texture = first_source_texture.get_resized(GenerationGlobals.renderer, render_size)

	# Setup weight texture generator -------------------------------------------
	_weight_texture_generator = WeightTextureGenerator.factory_create(
		params.weight_texture_generator_params.weight_texture_generator_type)
	_weight_texture_generator.set_params(params.weight_texture_generator_params)

	# Setup shape generator ----------------------------------------------------
	shape_generator = ShapeGenerator.factory_create(params.shape_generator_type)
	shape_generator.params = params.shape_generator_params
	shape_generator.target_texture = target_texture
	shape_generator.source_texture = source_texture
	shape_generator.setup()

	
func _init() -> void:
	_similarity_delta_e_metric = Metric.factory_create(Metric.Type.DELTA_E_1976)
	_user_mask_generator = UserMaskGenerator.new()

func _compute_similarity() -> void:
	# Computes the current normalized progress -----------------------------------------------------
	_similarity_delta_e_metric.target_texture = target_texture
	_similarity_delta_e_metric.weight_texture = weight_texture
	_similarity_delta_e_metric.mask_texture = user_mask_texture
	metric_value = _similarity_delta_e_metric.compute(source_texture)
	
	# Normalizes deltaE progress from range [0.0, 100.0]
	var max_error = 0.31
	var mapped_similarity = -(max_error - metric_value) / max_error
	similarity = clampf(1.0 - mapped_similarity * 0.01, 0.0, 1.0)
