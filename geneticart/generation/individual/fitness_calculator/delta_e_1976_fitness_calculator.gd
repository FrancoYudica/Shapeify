extends FitnessCalculator

var metric: DeltaEMetric

func _init() -> void:
	metric = load("res://generation/metric/delta_e/delta_e_1976.gd").new()

func calculate_fitness(
	individual: Individual,
	source_texture: RendererTexture) -> void:
	individual.fitness = metric.compute(source_texture)

func _target_texture_set():
	metric.target_texture = target_texture
