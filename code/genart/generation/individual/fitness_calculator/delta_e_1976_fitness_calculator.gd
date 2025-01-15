extends FitnessCalculator

var metric: DeltaEMetric
var _individual_renderer: IndividualRenderer

func _init() -> void:
	metric = load("res://generation/metric/delta_e/delta_e_1976_mean.gd").new()
	_individual_renderer = IndividualRenderer.new()

func calculate_fitness(
	individual: Individual,
	source_texture: RendererTexture) -> void:
	_individual_renderer.source_texture = source_texture
	_individual_renderer.render_individual(individual)
	
	metric.weight_texture = weight_texture

	var individual_source_texture = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)
	
	# Mapps error to normalized accuracy
	individual.fitness = 1.0 - metric.compute(individual_source_texture) * 0.01

func _target_texture_set():
	metric.target_texture = target_texture
