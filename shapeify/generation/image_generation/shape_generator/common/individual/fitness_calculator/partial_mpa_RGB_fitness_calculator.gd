extends FitnessCalculator

var metric: MPAPartialMetric
var _shape_renderer: ShapeRenderer

func _init() -> void:
	metric = load("res://generation/partial_metric/mpa/mpa_RGB_partial_metric.gd").new()
	_shape_renderer = ShapeRenderer.new()
	

func calculate_fitness(
	individual: Individual,
	source_texture: LocalTexture) -> void:
	
	metric.weight_texture = weight_texture
	
	# Gets individual's source texture
	var renderer: LocalRenderer = GenerationGlobals.renderer
	ShapeRenderer.render_shape(
		renderer,
		source_texture,
		individual)
	var individual_source_texture = renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.COLOR)
	
	# Sets texture parameters and calculates fitness with partial metric
	metric.source_texture = source_texture
	metric.new_source_texture = individual_source_texture

	# Maps normalized bounding rect to canvas bounding rect
	var normalized_bounding_rect = individual.get_bounding_rect()
	var bounding_rect = Rect2i(
		normalized_bounding_rect.position.x * source_texture.get_width(),
		normalized_bounding_rect.position.y * source_texture.get_height(),
		max(1.0, normalized_bounding_rect.size.x * source_texture.get_width()),
		max(1.0, normalized_bounding_rect.size.y * source_texture.get_height())
	)

	individual.fitness = metric.compute(bounding_rect)

func _target_texture_set():
	metric.target_texture = target_texture
