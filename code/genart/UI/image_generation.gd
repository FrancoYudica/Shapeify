extends Node

signal generation_started
signal generation_finished
signal shape_generated(shape: Shape)
signal target_texture_updated
signal generation_cleared


var image_generator: ImageGenerator
var details := ImageGenerationDetails.new()
var is_generating := false

## This method is called from the root of the application to ensure that all the nodes are ready
## to receive signals
func application_ready() -> void:
	# Image generator
	image_generator = ImageGenerator.new()
	image_generator.shape_generated.connect(
		func(shape): 
			call_deferred("_emit_shape_generated_signal", shape))
	
	set_target_texture(Globals.settings.image_generator_params.target_texture)
	
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

func set_target_texture(target_texture: RendererTexture):

	
	if target_texture == null:
		Notifier.notify_error("Dropped texture is null. File format not supported")
		return
	
	# If the pixel count is greater than the limit, the texture is downscaled to
	# satisfy the pixel count constraint
	var src_width =  target_texture.get_width()
	var src_height = target_texture.get_height()
	var pixel_count = src_width * src_height
	var final_texture_size: Vector2 = Vector2(src_width, src_height)
	
	if pixel_count > Constants.MAX_PIXEL_COUNT:
		var aspect_ratio = float(src_width) / src_height
		var new_height = floori(sqrt(Constants.MAX_PIXEL_COUNT / aspect_ratio))
		var new_width = floori(aspect_ratio * new_height)
		final_texture_size = Vector2(new_width, new_height)
		
		Notifier.notify_warning(
			"Target texture resolution is %sx%s, which has too many pixels to process.\n\
			Target texture was downscaled to resolution %sx%s. \n\
			Keep in mind that larger textures take longer to compute" % [
			src_width,
			src_height,
			new_width,
			new_height
		])
	
	const TARGET_SIZE = 512
	var width_scale = float(TARGET_SIZE) / final_texture_size.x
	var height_scale = float(TARGET_SIZE) / final_texture_size.y
	Globals.settings.render_scale = min(min(width_scale, height_scale), 1.0)
	Renderer.begin_frame(Vector2i(final_texture_size.x, final_texture_size.y))
	Renderer.render_sprite(
		final_texture_size * 0.5,
		final_texture_size,
		0.0,
		Color.WHITE,
		target_texture,
		0)
	Renderer.end_frame()
		
	target_texture = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR).copy()

	if target_texture == null or not target_texture.is_valid():
		Notifier.notify_error("Unable to load texture")
		return
	
	Globals.settings.image_generator_params.target_texture = target_texture
	clear_progress()
	target_texture_updated.emit()
	
	
func _emit_shape_generated_signal(shape: Shape):
	details.shapes.append(shape)
	shape_generated.emit(shape)

func _begin_image_generation():
	is_generating = true
	var clock := Clock.new()
	var params := Globals.settings.image_generator_params
	image_generator.params = params
	details.executed_count += 1
	
	# Renders source texture
	var render_details = details.copy()
	render_details.shapes = details.shapes
	render_details.clear_color = details.clear_color
	render_details.viewport_size = params.target_texture.get_size() * Globals.settings.render_scale
	ImageGenerationRenderer.render_image_generation(Renderer, render_details)
	var source_texture := Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR).copy()
	
	# Generates the image
	var output_texture = image_generator.generate_image(source_texture)
	details.time_taken_ms += clock.elapsed_ms()
	is_generating = false
	call_deferred("emit_signal", "generation_finished")
