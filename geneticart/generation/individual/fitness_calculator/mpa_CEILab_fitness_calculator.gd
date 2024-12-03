extends FitnessCalculator

var mpa: MPAFitnessMetric

func _init() -> void:
	mpa = load("res://generation/metric/mpa/mpa_CEILab_fitnenss_metric.gd").new()

func calculate_fitness(
	individual: Individual,
	source_texture: RendererTexture) -> void:
	individual.fitness = mpa.compute(source_texture)

func _target_texture_set():
	mpa.target_texture = target_texture
