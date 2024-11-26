extends FitnessCalculator

@export var error_metric: ErrorMetric

func calculate_fitness(
	individual: Individual,
	source_texture_rd_rid: RID) -> void:
	individual.fitness = 1.0 - error_metric.compute(source_texture_rd_rid)


func _target_texture_set():
	error_metric.target_texture_rd_rid = target_texture_rd_rid
