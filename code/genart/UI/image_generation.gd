extends Node

var image_generator: ImageGenerator

var _clear_color_strategy: ClearColorStrategy

## This method is called from the root of the application to ensure that all the nodes are ready
## to receive signals
func application_ready() -> void:
	_setup_references()
	Globals.image_generator_params_updated.connect(image_generator.setup)

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

	Globals.generation_started.emit()
	# Executes the generation in another thread to avoild locking the UI
	WorkerThreadPool.add_task(_begin_image_generation)

func stop():
	image_generator.stop()

func refresh_target_texture():
	clear_progress()
	Globals.target_texture_updated.emit()
	
func _setup_references():
	# Image generator
	image_generator = ImageGenerator.new()
	image_generator.shape_generated.connect(
		func(shape): 
			call_deferred("_emit_shape_generated_signal", shape))
	refresh_target_texture()
	
	image_generator.weight_texture_updated.connect(
		func(t):
			Globals.weight_texture_updated.emit(t))
	
func _emit_shape_generated_signal(shape: Shape):
	Globals.image_generation_details.shapes.append(shape)
	Globals.shape_generated.emit(shape)

func _begin_image_generation():
	var clock := Clock.new()
	var params := Globals.settings.image_generator_params
	image_generator.params = params
	Globals.image_generation_details.executed_count += 1
	
	# Renders source texture
	var details := ImageGenerationDetails.new()
	details.shapes = Globals.image_generation_details.shapes
	details.clear_color = Globals.image_generation_details.clear_color
	details.viewport_size = params.target_texture.get_size() * params.render_scale
	ImageGenerationRenderer.render_image_generation(Renderer, details)
	var source_texture := Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR).copy()
	
	# Generates the image
	var output_texture = image_generator.generate_image(source_texture)
	Globals.image_generation_details.time_taken_ms += clock.elapsed_ms()
	
	Globals.call_deferred("emit_signal", "generation_finished")
	
	
func _clear_image_generation_details():
	
	var params := Globals.settings.image_generator_params
	
	var target_texture := params.target_texture
	_clear_color_strategy = ClearColorStrategy.factory_create(params.clear_color_type)

	_clear_color_strategy.sample_texture = target_texture
	_clear_color_strategy.set_params(params.clear_color_params)

	Globals.image_generation_details.time_taken_ms = 0.0
	Globals.image_generation_details.executed_count = 0
	Globals.image_generation_details.shapes.clear()
	Globals.image_generation_details.clear_color = _clear_color_strategy.get_clear_color()
	Globals.image_generation_details.viewport_size = target_texture.get_size()
	
	# Creates to image texture and then to RD local texture
	Globals.generation_cleared.emit()
