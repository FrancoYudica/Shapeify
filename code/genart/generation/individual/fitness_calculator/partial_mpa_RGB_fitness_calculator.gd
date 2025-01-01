extends FitnessCalculator

var metric: MPAPartialMetric
var _individual_renderer: IndividualRenderer

func _init() -> void:
	metric = load("res://generation/partial_metric/mpa/mpa_RGB_partial_metric.gd").new()
	_individual_renderer = IndividualRenderer.new()
	

func calculate_fitness(
	individual: Individual,
	source_texture: RendererTexture) -> void:
	
	# Gets individual's source texture
	_individual_renderer.source_texture = source_texture
	_individual_renderer.render_individual(individual)
	var individual_source_texture = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)
	
	# Sets texture parameters and calculates fitness with partial metric
	metric.source_texture = source_texture
	metric.new_source_texture = individual_source_texture
	individual.fitness = metric.compute(individual.get_bounding_rect())

func _target_texture_set():
	metric.target_texture = target_texture
