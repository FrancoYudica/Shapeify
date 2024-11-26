extends FitnessCalculator

@export var error_metric: ErrorMetric

func calculate_fitness(
	individual: Individual,
	source_texture: Texture2D) -> void:
	individual.fitness = 1.0 - error_metric.compute(source_texture)

func calculate_fitness_rd_id(
	individual: Individual,
	source_texture_rd_id: RID) -> void:
	individual.fitness = 1.0 - error_metric.compute_rd(source_texture_rd_id)

func _target_texture_set():
	error_metric.target_texture = target_texture
