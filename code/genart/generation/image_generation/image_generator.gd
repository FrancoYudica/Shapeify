class_name ImageGenerator extends RefCounted

signal shape_generated(shape: Shape)

var params: ImageGeneratorParams

var shape_generator: ShapeGenerator

var _mutex: Mutex = Mutex.new()
var texture_mutex := Mutex.new()
var _stop: bool = false
var _stop_condition: StopCondition
var _shape_renderer: ShapeRenderer
var _generating: bool = false
var _weight_texture_generator: WeightTextureGenerator

var weight_texture: RendererTexture

func update_target_texture(target_texture: RendererTexture):
	shape_generator.update_target_texture(target_texture)

func stop():
	_mutex.lock()
	_stop = true
	_mutex.unlock()

func get_progress() -> float:
	if _stop_condition == null or not _generating:
		return 0.0
	return _stop_condition.get_progress()

func generate_image(first_src_texture: RendererTexture) -> RendererTexture:
	
	Profiler.image_generation_began(params)
	
	setup()
	
	# In case the image generator starts with some progress
	if first_src_texture != null:
		shape_generator.source_texture = first_src_texture
		
	var source_texture = shape_generator.source_texture
	var target_texture = params.shape_generator_params.target_texture
	_shape_renderer.source_texture = source_texture
	
	_generating = true
	_stop_condition.began_generating()
	while not _stop_condition.should_stop():
		# Checks if the algorithm should stop executing
		_mutex.lock()
		if _stop:
			_mutex.unlock()
			break
		_mutex.unlock()
		
		# Generates weight texture
		texture_mutex.lock()
		weight_texture = _weight_texture_generator.generate(
			_stop_condition.get_progress(),
			target_texture)
		texture_mutex.unlock()
		
		if weight_texture == null:
			Notifier.call_deferred("notify_error", "Weight texture is null. Ensure a weight texture is specified")
			break
		
		if weight_texture.get_size() != target_texture.get_size():
			Notifier.call_deferred("notify_error", ("Weight texture doesn't match target texture resolution. Weight(%sx%s) Target(%sx%s)" % [weight_texture.get_width(), weight_texture.get_height(), target_texture.get_width(), target_texture.get_height()]))
			break
		
		shape_generator.weight_texture = weight_texture
		
		# Generates Shape
		texture_mutex.lock()
		var shape: Shape = shape_generator.generate_shape()
		
		# Renders the shape onto the source texture
		_shape_renderer.render_shape(shape)
		source_texture.copy_contents(_shape_renderer.get_color_attachment_texture())
		texture_mutex.unlock()
		
		shape_generated.emit(shape)
		_stop_condition.shape_generated(
			source_texture,
			target_texture,
			shape)
	
	_generating = false
	Profiler.image_generation_finished(shape_generator.source_texture)
	
	return shape_generator.source_texture


var _current_shape_generator_type: int = -1

func setup():
	_stop = false
	_stop_condition = StopCondition.factory_create(params.stop_condition)
	_stop_condition.set_params(params.stop_condition_params)
	
	# Setup shape generator -----------------------------------------------
	if _current_shape_generator_type != params.shape_generator_type:
		shape_generator = ShapeGenerator.factory_create(params.shape_generator_type)
		_current_shape_generator_type = params.shape_generator_type

	shape_generator.params = params.shape_generator_params
	
	_weight_texture_generator = WeightTextureGenerator.factory_create(params.weight_texture_generator_type)
	_weight_texture_generator.set_params(params.weight_texture_generator_params)
	
func _init() -> void:
	_shape_renderer = ShapeRenderer.new()


func copy_source_texture_contents(dest: Texture2DRD):
	
	if not dest.texture_rd_rid.is_valid():
		return
	
	texture_mutex.lock()
	
	RenderingCommon.texture_copy(
		shape_generator.source_texture.rd_rid,
		dest.texture_rd_rid,
		Renderer.rd,
		RenderingServer.get_rendering_device()
	)
	texture_mutex.unlock()

func copy_weight_texture_contents(dest: Texture2DRD):
	
	if not dest.texture_rd_rid.is_valid():
		return
	
	if weight_texture == null:
		return
	
	texture_mutex.lock()
	
	RenderingCommon.texture_copy(
		weight_texture.rd_rid,
		dest.texture_rd_rid,
		Renderer.rd,
		RenderingServer.get_rendering_device()
	)
	texture_mutex.unlock()
