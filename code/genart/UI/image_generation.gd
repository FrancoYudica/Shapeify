extends Node

signal generation_started
signal generation_finished
signal shape_generated(shape: Shape)
signal target_texture_updated
signal generation_cleared

var image_generator: ImageGenerator
var image_generation_details := ImageGenerationDetails.new()

var _clear_color_strategy: ClearColorStrategy

func clear_progress():
	_clear_image_generation_details()

func generate() -> void:
	
	if Globals \
		.settings \
		.image_generator_params \
		.shape_generator_params \
		.shape_spawner_params \
		.textures.size() == 0:
			
		Notifier.notify_warning("Unable to begin generation without textures.")
		return

	generation_started.emit()
	# Executes the generation in another thread to avoild locking the UI
	WorkerThreadPool.add_task(_begin_image_generation)

func stop():
	image_generator.stop()

func refresh_target_texture():
	clear_progress()
	target_texture_updated.emit()

func _ready() -> void:
	_setup_references()
	Globals.image_generator_params_updated.connect(image_generator.setup)
	
func _setup_references():
	# Image generator
	image_generator = ImageGenerator.new()
	image_generator.params = Globals.settings.image_generator_params
	image_generator.shape_generated.connect(
		func(shape): 
			call_deferred("_emit_shape_generated_signal", shape))
	image_generator.setup()
	clear_progress()
	
func _emit_shape_generated_signal(shape: Shape):
	image_generation_details.shapes.append(shape)
	shape_generated.emit(shape)

func _begin_image_generation():
	var clock := Clock.new()
	var src = image_generation_details.generated_texture.copy()
	image_generator.params = Globals.settings.image_generator_params
	image_generation_details.executed_count += 1
	var output_texture = image_generator.generate_image(src)
	image_generation_details.time_taken_ms += clock.elapsed_ms()
	
	# Stores the generated texture
	image_generation_details.generated_texture.copy_contents(output_texture)
	
	call_deferred("emit_signal", "generation_finished")
	
	
func _clear_image_generation_details():
	
	var target_texture: RendererTexture = Globals \
										.settings \
										.image_generator_params \
										.target_texture
	_clear_color_strategy = ClearColorStrategy.factory_create(
		Globals \
		.settings \
		.image_generator_params \
		.clear_color_type)

	_clear_color_strategy.sample_texture = target_texture
	_clear_color_strategy.set_params(
		Globals \
		.settings \
		.image_generator_params \
		.clear_color_params
	)

	image_generation_details.time_taken_ms = 0.0
	image_generation_details.executed_count = 0
	image_generation_details.shapes.clear()
	image_generation_details.clear_color = _clear_color_strategy.get_clear_color()
	image_generation_details.render_scale = Globals.settings.image_generator_params.render_scale
	image_generation_details.viewport_size = target_texture.get_size() * Globals.settings.image_generator_params.render_scale
	
	# Initializes generated texture
	var img = ImageUtils.create_monochromatic_image(
		image_generation_details.viewport_size.x,
		image_generation_details.viewport_size.y,
		image_generation_details.clear_color)
	
	# Creates to image texture and then to RD local texture
	var generated_global_rd = ImageTexture.create_from_image(img)
	image_generation_details.generated_texture = RendererTexture.load_from_texture(generated_global_rd)
	generation_cleared.emit()
