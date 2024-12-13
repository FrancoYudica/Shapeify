extends Node

signal generation_started
signal generation_finished
signal individual_generated(individual: Individual)
signal target_texture_updated

@export_group("Metric")
@export var metric_scripts: Array[GDScript]

var image_generator: ImageGenerator
var metrics: Array[Metric]
var image_generation_details := ImageGenerationDetails.new()

func clear_progress():
	_clear_image_generation_details()
	image_generator.individual_generator.clear_source_texture()

func generate() -> void:
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
	
	for metric_script in metric_scripts:
		var metric = metric_script.new() as Metric
		if metric == null:
			push_error("Trying to create a metric with invalid script: %s" % metric_script.resource_path)
			continue
			
		metrics.append(metric)
	
	
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
	var src = image_generation_details.generated_texture.copy()
	image_generator.generate_image(src)
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
	
	image_generation_details.individuals.clear()
	image_generation_details.clear_color = ImageUtils.get_texture_average_color(
		target_texture)
	image_generation_details.viewport_size = target_texture.get_size()
	
	# Initializes generated texture
	var img = ImageUtils.create_monochromatic_image(
		target_texture.get_width(),
		target_texture.get_height(),
		image_generation_details.clear_color)
	
	# Creates to image texture and then to RD local texture
	var generated_global_rd = ImageTexture.create_from_image(img)
	image_generation_details.generated_texture = RendererTexture.load_from_texture(generated_global_rd)
