extends Node

signal generation_started
signal generation_finished
signal shape_generated(shape: Shape)
signal target_texture_updated
signal generation_cleared
signal weight_texture_updated(weight_texture: RendererTexture)

var image_generator: ImageGenerator
var details := ImageGenerationDetails.new()

## This method is called from the root of the application to ensure that all the nodes are ready
## to receive signals
func application_ready() -> void:
	# Image generator
	image_generator = ImageGenerator.new()
	image_generator.shape_generated.connect(
		func(shape): 
			call_deferred("_emit_shape_generated_signal", shape))

	refresh_target_texture()
	
	image_generator.weight_texture_updated.connect(
		func(t):
			weight_texture_updated.emit(t))
	
func clear_progress():
	var params := Globals.settings.image_generator_params
	
	# Creates clear color strategy
	var clear_color_strategy = ClearColorStrategy.factory_create(params.clear_color_type)
	clear_color_strategy.sample_texture = params.target_texture
	clear_color_strategy.set_params(params.clear_color_params)
	
	# Crates new ImageGenerationDetails
	details = ImageGenerationDetails.new()
	details.clear_color = clear_color_strategy.get_clear_color()
	details.viewport_size = params.target_texture.get_size()
	
	# Creates to image texture and then to RD local texture
	generation_cleared.emit()

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
	
func _emit_shape_generated_signal(shape: Shape):
	details.shapes.append(shape)
	shape_generated.emit(shape)

func _begin_image_generation():
	var clock := Clock.new()
	var params := Globals.settings.image_generator_params
	image_generator.params = params
	details.executed_count += 1
	
	# Renders source texture
	var render_details = details.copy()
	render_details.shapes = details.shapes
	render_details.clear_color = details.clear_color
	render_details.viewport_size = params.target_texture.get_size() * params.render_scale
	ImageGenerationRenderer.render_image_generation(Renderer, render_details)
	var source_texture := Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR).copy()
	
	# Generates the image
	var output_texture = image_generator.generate_image(source_texture)
	details.time_taken_ms += clock.elapsed_ms()
	
	call_deferred("emit_signal", "generation_finished")
