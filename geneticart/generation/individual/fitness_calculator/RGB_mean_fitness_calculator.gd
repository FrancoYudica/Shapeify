extends FitnessCalculator

var metric: MeanFitnessMetric

func _init() -> void:
	metric = load("res://generation/metric/mean_fitness/RGB_mean_fitnenss_metric_compute.gd").new()

func calculate_fitness(
	individual: Individual,
	source_texture: RendererTexture) -> void:
	individual.fitness = metric.compute(source_texture)

func _target_texture_set():
	metric.target_texture = target_texture
