extends FitnessCalculator

var metric: MSEMetric
var _individual_renderer: IndividualRenderer

func _init() -> void:
	metric = load("res://generation/metric/mse/mse_cpu.gd").new()
	_individual_renderer = IndividualRenderer.new()

func calculate_fitness(
	individual: Individual,
	source_texture: RendererTexture) -> void:
	
	_individual_renderer.source_texture = source_texture
	_individual_renderer.render_individual(individual)
	var individual_source_texture = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)
	individual.fitness = 1.0 - metric.compute(individual_source_texture)

func _target_texture_set():
	metric.target_texture = target_texture
