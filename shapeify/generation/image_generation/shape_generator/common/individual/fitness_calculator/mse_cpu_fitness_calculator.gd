extends FitnessCalculator

var metric: MSEMetric

func _init() -> void:
	metric = load("res://generation/metric/mse/mse_cpu.gd").new()

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
	individual.fitness = 1.0 - metric.compute(individual_source_texture)

func _target_texture_set():
	metric.target_texture = target_texture
