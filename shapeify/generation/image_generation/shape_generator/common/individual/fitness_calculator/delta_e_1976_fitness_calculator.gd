extends FitnessCalculator

var metric: DeltaEMetric

func _init() -> void:
	metric = Metric.factory_create(Metric.Type.DELTA_E_1976) as DeltaEMetric

func calculate_fitness(
	individual: Individual,
	source_texture: LocalTexture) -> void:
	metric.weight_texture = weight_texture
	
	var renderer: LocalRenderer = GenerationGlobals.renderer
	ShapeRenderer.render_shape(
		renderer,
		source_texture,
		individual)
	var individual_source_texture = renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.COLOR)
	
	# Mapps error to normalized accuracy
	individual.fitness = 1.0 - metric.compute(individual_source_texture) * 0.01

func _target_texture_set():
	metric.target_texture = target_texture
