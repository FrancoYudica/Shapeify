extends FitnessCalculator

var error_metric: ErrorMetric

func calculate_fitness(
	individual: Individual,
	source_texture: RendererTexture) -> void:
	individual.fitness = error_metric.compute(source_texture)

func _target_texture_set():
	error_metric.target_texture = target_texture
