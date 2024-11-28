# An algorithm that, given a set of parameters, a target texture, and a source texture, 
# generates the best possible individual. This individual, when added to the source texture, 
# minimizes the error metric relative to the target texture.
class_name IndividualGenerator extends RefCounted

var params: IndividualGeneratorParams

var average_color_sampler: AverageColorSampler
var fitness_calculator: FitnessCalculator
var individual_renderer: IndividualRenderer
var populator: Populator

var source_texture: RendererTexture

var _initialized = false

func initialize(generator_params: IndividualGeneratorParams):
	
	params = generator_params
	
	if not params.target_texture.is_valid():
		printerr("Trying to initialize IndividualGenerator but target_texture is invalid")
		return
		
	fitness_calculator.target_texture = params.target_texture
	average_color_sampler.sample_texture = params.target_texture

	if source_texture == null or not source_texture.is_valid():
		_initialize_src_image()

	_initialized = true


func generate_individual() -> Individual:
	
	if not _initialized:
		printerr("IndividialGenerator not initialized")
		return
	
	_setup()
	return _generate()

func _setup():
	individual_renderer.source_texture = source_texture

func _generate() -> Individual:
	return

func _initialize_src_image():
	
	# Renders to get an ID texture full with ID = 1.0
	Renderer.begin_frame(params.target_texture.get_size())
	Renderer.render_sprite(
		params.target_texture.get_size() * 0.5,
		params.target_texture.get_size(),
		0.0,
		Color.WHITE,
		params.target_texture,
		1.0
	)
	Renderer.end_frame()
	
	# The initial color of the source texture is the average color of target texture
	average_color_sampler.id_texture = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.UID)
	var average_color = average_color_sampler.sample_rect(
		Rect2i(
			Vector2i.ZERO, 
			Vector2i(
				params.target_texture.get_width(),
				params.target_texture.get_height()
			)
		)
	)
	
	var img = ImageUtils.create_monochromatic_image(
		params.target_texture.get_width(),
		params.target_texture.get_height(),
		average_color)
	
	# Creates to image texture and then to RD local texture
	var source_texture_global_rd = ImageTexture.create_from_image(img)
	source_texture = RendererTexture.load_from_texture(source_texture_global_rd)
