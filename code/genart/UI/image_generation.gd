extends Node

signal generation_started
signal generation_finished
signal individual_generated(individual: Individual)
signal target_texture_updated
signal generation_cleared

@export var notification_popup: Control


var image_generator: ImageGenerator
var image_generation_details := ImageGenerationDetails.new()

var _clear_color_strategy: ClearColorStrategy

func clear_progress():
	_clear_image_generation_details()

func generate() -> void:
	
	if Globals \
		.settings \
		.image_generator_params \
		.individual_generator_params \
		.populator_params \
		.textures.size() == 0:
		notification_popup.message = "Unable to begin generation without textures."
		notification_popup.visible = true
		return

	generation_started.emit()
	# Executes the generation in another thread to avoild locking the UI
	WorkerThreadPool.add_task(_begin_image_generation)

func stop():
	image_generator.stop()

func refresh_target_texture():
	image_generator.update_target_texture(
		Globals \
		.settings \
		.image_generator_params \
		.individual_generator_params \
		.target_texture)
	
	target_texture_updated.emit()
	clear_progress()

func _ready() -> void:
	_setup_references()
	
func _setup_references():
	# Image generator
	image_generator = ImageGenerator.new()
	image_generator.params = Globals.settings.image_generator_params
	image_generator.individual_generated.connect(
		func(i): 
			call_deferred("_emit_individual_generated_signal", i))
	image_generator.setup()
	clear_progress()
	target_texture_updated.emit()
	

func _emit_individual_generated_signal(individual: Individual):
	image_generation_details.individuals.append(individual)
	individual_generated.emit(individual)

func _begin_image_generation():
	var clock := Clock.new()
	var src = image_generation_details.generated_texture.copy()
	image_generator.generate_image(src)
	image_generation_details.time_taken_ms += clock.elapsed_ms()
	image_generation_details.executed_count += 1
	call_deferred("emit_signal", "generation_finished")
	
	# Renders the texture and stores the generated texture
	image_generator.texture_mutex.lock()
	ImageGenerationRenderer.render_image_generation(Renderer, image_generation_details)
	var color_attachment := Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)
	image_generation_details.generated_texture.copy_contents(color_attachment)
	image_generator.texture_mutex.unlock()
	
	
func _clear_image_generation_details():
	
	var target_texture: RendererTexture = Globals \
										.settings \
										.image_generator_params \
										.individual_generator_params \
										.target_texture
	_clear_color_strategy = ClearColorStrategyFactory.create(
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
	image_generation_details.individuals.clear()
	image_generation_details.clear_color = _clear_color_strategy.get_clear_color()
	image_generation_details.viewport_size = target_texture.get_size()
	
	# Initializes generated texture
	var img = ImageUtils.create_monochromatic_image(
		target_texture.get_width(),
		target_texture.get_height(),
		image_generation_details.clear_color)
	
	# Creates to image texture and then to RD local texture
	var generated_global_rd = ImageTexture.create_from_image(img)
	image_generation_details.generated_texture = RendererTexture.load_from_texture(generated_global_rd)
	image_generator.individual_generator.source_texture = image_generation_details.generated_texture.copy()
	generation_cleared.emit()
