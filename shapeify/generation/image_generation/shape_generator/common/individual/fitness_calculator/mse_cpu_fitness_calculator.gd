extends FitnessCalculator

var metric: MSEMetric
var _shape_renderer: ShapeRenderer

func _init() -> void:
	metric = load("res://generation/metric/mse/mse_cpu.gd").new()
	_shape_renderer = ShapeRenderer.new()

func calculate_fitness(
	individual: Individual,
	source_texture: RendererTexture) -> void:
	
	metric.weight_texture = weight_texture
	
	_shape_renderer.source_texture = source_texture
	_shape_renderer.render_shape(individual)
	var individual_source_texture = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)
	individual.fitness = 1.0 - metric.compute(individual_source_texture)

func _target_texture_set():
	metric.target_texture = target_texture
