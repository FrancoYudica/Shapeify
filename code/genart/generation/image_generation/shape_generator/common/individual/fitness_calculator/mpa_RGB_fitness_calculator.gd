extends FitnessCalculator

var metric: MPAMetric
var _shape_renderer: ShapeRenderer

func _init() -> void:
	metric = Metric.factory_create(Metric.Type.MPA_RGB) as MPAMetric
	_shape_renderer = ShapeRenderer.new()

func calculate_fitness(
	individual: Individual,
	source_texture: RendererTexture) -> void:
	
	metric.weight_texture = weight_texture
	
	_shape_renderer.source_texture = source_texture
	_shape_renderer.render_shape(individual)
	var individual_source_texture = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)
	individual.fitness = metric.compute(individual_source_texture)
	
func _target_texture_set():
	metric.target_texture = target_texture
