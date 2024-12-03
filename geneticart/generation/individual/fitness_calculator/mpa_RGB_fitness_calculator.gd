extends FitnessCalculator

var metric: MPAFitnessMetric

func _init() -> void:
	metric = load("res://generation/metric/mpa/mpa_RGB_fitnenss_metric.gd").new()

func calculate_fitness(
	individual: Individual,
	source_texture: RendererTexture) -> void:
	individual.fitness = metric.compute(source_texture)

func _target_texture_set():
	metric.target_texture = target_texture
