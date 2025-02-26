extends FitnessCalculator

var metric: MPAMetric

func _init() -> void:
	metric = Metric.factory_create(Metric.Type.MPA_CEILab) as MPAMetric

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
	
	individual.fitness = metric.compute(individual_source_texture)

func _target_texture_set():
	metric.target_texture = target_texture
