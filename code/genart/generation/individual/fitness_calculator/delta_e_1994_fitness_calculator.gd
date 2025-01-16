extends FitnessCalculator

var metric: DeltaEMetric
var _individual_renderer: IndividualRenderer

func _init() -> void:
	metric = Metric.factory_create(Metric.Type.DELTA_E_1994) as DeltaEMetric
	_individual_renderer = IndividualRenderer.new()

func calculate_fitness(
	individual: Individual,
	source_texture: RendererTexture) -> void:

	metric.weight_texture = weight_texture

	_individual_renderer.source_texture = source_texture
	_individual_renderer.render_individual(individual)
	var individual_source_texture = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)
	
	# Mapps error to normalized accuracy
	individual.fitness = 1.0 - metric.compute(individual_source_texture) * 0.01

func _target_texture_set():
	metric.target_texture = target_texture
