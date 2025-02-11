class_name ImageGenerator extends RefCounted

signal shape_generated(shape: Shape)
signal weight_texture_updated(weight_texture: RendererTexture)
var params: ImageGeneratorParams

var shape_generator: ShapeGenerator

var _stop_mutex: Mutex = Mutex.new()
var _stop: bool = false
var _stop_condition: StopCondition
var _shape_renderer: ShapeRenderer

var _similarity_delta_e_metric: DeltaEMetric

var _generating: bool = false
var _weight_texture_generator: WeightTextureGenerator

var metric_value: float = 0.0
var similarity: float = 0.0

var weight_texture: RendererTexture

func stop():
	_stop_mutex.lock()
	_stop = true
	_stop_mutex.unlock()

func get_progress() -> float:
	if _stop_condition == null or not _generating:
		return 0.0
	return _stop_condition.get_progress()

func generate_image(first_src_texture: RendererTexture) -> RendererTexture:
	
	Profiler.image_generation_began(params)
	
	setup()
	
	# Resizes the source texture
	var source_texture = RenderingCommon.resize_texture(
		first_src_texture,
		params.render_scale * params.target_texture.get_size())
	params.shape_generator_params.source_texture = source_texture
	
	shape_generator.setup()

	var target_texture = params.shape_generator_params.target_texture
	_shape_renderer.source_texture = source_texture
	
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
		
		# Computes the similarity between the target and source texture
		_compute_similarity(target_texture, source_texture)
		
		# Generates weight texture every X shapes
		if iteration % 20 == 0:
			weight_texture = _weight_texture_generator.generate(
				similarity,
				target_texture,
				source_texture)
			weight_texture_updated.emit(weight_texture)
		
		if weight_texture == null:
			Notifier.call_deferred("notify_error", "Weight texture is null. Ensure a weight texture is specified")
			break
		
		if weight_texture.get_size() != target_texture.get_size():
			Notifier.call_deferred("notify_error", ("Weight texture doesn't match target texture resolution. Weight(%sx%s) Target(%sx%s)" % [weight_texture.get_width(), weight_texture.get_height(), target_texture.get_width(), target_texture.get_height()]))
			break
		
		shape_generator.weight_texture = weight_texture
		
		# Generates Shape
		var shape: Shape = shape_generator.generate_shape(similarity)
		# Renders the shape onto the source texture
		_shape_renderer.render_shape(shape)
		source_texture.copy_contents(_shape_renderer.get_color_attachment_texture())
		
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

func setup():
	_stop = false
	
	# Setup stop condition -----------------------------------------------------
	_stop_condition = StopCondition.factory_create(params.stop_condition)
	_stop_condition.set_params(params.stop_condition_params)
	
	# Scales target texture ----------------------------------------------------
	params.shape_generator_params.target_texture = RenderingCommon.resize_texture(
		params.target_texture, 
		params.render_scale * params.target_texture.get_size())

	# Setup shape generator ----------------------------------------------------
	shape_generator = ShapeGenerator.factory_create(params.shape_generator_type)
	shape_generator.params = params.shape_generator_params

	# Setup weight texture generator ----------------------------------------------------
	_weight_texture_generator = WeightTextureGenerator.factory_create(
		params.weight_texture_generator_params.weight_texture_generator_type)
	_weight_texture_generator.set_params(params.weight_texture_generator_params)
	
func _init() -> void:
	_shape_renderer = ShapeRenderer.new()
	_similarity_delta_e_metric = Metric.factory_create(Metric.Type.DELTA_E_1976)

func _compute_similarity(
	target_texture,
	source_texture
) -> void:
	# Computes the current normalized progress -----------------------------------------------------
	_similarity_delta_e_metric.target_texture = target_texture
	metric_value = _similarity_delta_e_metric.compute(source_texture)
	
	# Normalizes deltaE progress from range [0.0, 100.0]
	var max_error = 0.31
	var mapped_similarity = -(max_error - metric_value) / max_error
	similarity = clampf(1.0 - mapped_similarity * 0.01, 0.0, 1.0)
	
