class_name ImageGenerator extends RefCounted

signal individual_generated(individual: Individual)

var params: ImageGeneratorParams

var individual_generator: IndividualGenerator

var _mutex: Mutex = Mutex.new()
var texture_mutex := Mutex.new()
var _stop: bool = false
var _stop_condition: StopCondition
var _individual_renderer: IndividualRenderer
var _generating: bool = false

func update_target_texture(target_texture: RendererTexture):
	individual_generator.update_target_texture(target_texture)

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
		individual_generator.source_texture = first_src_texture
		
	var source_texture = individual_generator.source_texture
	_individual_renderer.source_texture = source_texture
	
	_generating = true
	_stop_condition.began_generating()
	while not _stop_condition.should_stop():
		# Checks if the algorithm should stop executing
		_mutex.lock()
		if _stop:
			_mutex.unlock()
			break
		_mutex.unlock()
		
		texture_mutex.lock()
		# Generates individual
		var individual: Individual = individual_generator.generate_individual()
		
		# Renders the individual onto the source texture
		_individual_renderer.render_individual(individual)
		source_texture.copy_contents(_individual_renderer.get_color_attachment_texture())
		texture_mutex.unlock()
		
		individual_generated.emit(individual)
		_stop_condition.individual_generated(individual)
	
	_generating = false
	Profiler.image_generation_finished(individual_generator.source_texture)
	
	return individual_generator.source_texture

func copy_source_texture_contents(dest: Texture2DRD):
	
	if not dest.texture_rd_rid.is_valid():
		return
	
	texture_mutex.lock()
	
	RenderingCommon.texture_copy(
		individual_generator.source_texture.rd_rid,
		dest.texture_rd_rid,
		Renderer.rd,
		RenderingServer.get_rendering_device()
	)
	texture_mutex.unlock()
	
	
var _current_individual_generator_type: int = -1

func setup():
	_stop = false
	_stop_condition = StopCondition.factory_create(params.stop_condition)
	_stop_condition.set_params(params.stop_condition_params)
	
	# Setup individual generator -----------------------------------------------
	if _current_individual_generator_type != params.individual_generator_type:
		individual_generator = IndividualGenerator.factory_create(params.individual_generator_type)
		_current_individual_generator_type = params.individual_generator_type
		individual_generator.params = params.individual_generator_params

func _init() -> void:
	_individual_renderer = load("res://generation/individual/individual_renderer.gd").new()
