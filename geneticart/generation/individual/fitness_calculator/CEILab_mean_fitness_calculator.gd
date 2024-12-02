extends FitnessCalculator

var median_fitness_metric: MeanFitnessMetric

func _init() -> void:
	median_fitness_metric = load("res://generation/metric/mean_fitness/CEILab_mean_fitnenss_metric_compute.gd").new()

func calculate_fitness(
	individual: Individual,
	source_texture: RendererTexture) -> void:
	individual.fitness = median_fitness_metric.compute(source_texture)

func _target_texture_set():
	median_fitness_metric.target_texture = target_texture
