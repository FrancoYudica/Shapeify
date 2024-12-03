# An algorithm that, given a set of parameters, a target texture, and a source texture, 
# generates the best possible individual. This individual, when added to the source texture, 
# minimizes the error metric relative to the target texture.
class_name IndividualGenerator extends RefCounted

var average_color_sampler: AverageColorSampler
var fitness_calculator: FitnessCalculator
var individual_renderer: IndividualRenderer
var populator: Populator

var source_texture: RendererTexture

var params: IndividualGeneratorParams:
	set(value):
		params = value
		update_target_texture(params.target_texture)

func update_target_texture(target_texture: RendererTexture):
	if not target_texture.is_valid():
		printerr("Trying to initialize IndividualGenerator but target_texture is invalid")
		return
		
	fitness_calculator.target_texture = target_texture
	average_color_sampler.sample_texture = target_texture
	clear_source_texture()

func generate_individual() -> Individual:
	
	if params == null:
		printerr("IndividialGenerator not initialized")
		return
	
	_setup()
	return _generate()

func clear_source_texture():
	
	var image_color: Color = Color.BLACK
	
	if params.clear_color_average:
	
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
		image_color = average_color_sampler.sample_rect(
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
		image_color)
	
	# Creates to image texture and then to RD local texture
	var source_texture_global_rd = ImageTexture.create_from_image(img)
	source_texture = RendererTexture.load_from_texture(source_texture_global_rd)

func _setup():
	individual_renderer.source_texture = source_texture

	# Setup populator params
	params.populator_params.position_bound_min = Vector2.ZERO
	params.populator_params.position_bound_max = source_texture.get_size()
	var max_width_height = maxf(source_texture.get_width(), source_texture.get_height())
	params.populator_params.size_bound_max = Vector2(max_width_height, max_width_height)

func _generate() -> Individual:
	return

## Applies settings and ensures that all the properties have valid values
func _fix_individual_properties(individual: Individual):
	
	# If the aspect ratio
	if params.keep_aspect_ratio:
		var aspect = float(individual.texture.get_height()) / individual.texture.get_width()
		individual.size.y = individual.size.x * aspect
	
	# Can't rotate
	if params.fixed_rotation:
		individual.rotation = params.fixed_rotation_angle
		
	# Clamps position
	if params.clamp_position_in_canvas:
		individual.position.x = clampi(individual.position.x, 0, params.target_texture.get_width())
		individual.position.y = clampi(individual.position.y, 0, params.target_texture.get_height())
