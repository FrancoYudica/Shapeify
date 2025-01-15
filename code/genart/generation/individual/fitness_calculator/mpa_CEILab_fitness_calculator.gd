extends FitnessCalculator

var metric: MPAMetric
var _individual_renderer: IndividualRenderer

func _init() -> void:
	metric = load("res://generation/metric/mpa/mpa_CEILab_metric.gd").new()
	_individual_renderer = IndividualRenderer.new()

func calculate_fitness(
	individual: Individual,
	source_texture: RendererTexture) -> void:
	
	metric.weight_texture = weight_texture
	
	_individual_renderer.source_texture = source_texture
	_individual_renderer.render_individual(individual)
	var individual_source_texture = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)
	individual.fitness = metric.compute(individual_source_texture)

func _target_texture_set():
	metric.target_texture = target_texture
