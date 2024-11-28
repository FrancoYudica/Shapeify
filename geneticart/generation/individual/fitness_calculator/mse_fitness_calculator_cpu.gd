extends FitnessCalculator

var mse_metric: MSEMetric

func _init() -> void:
	mse_metric = load("res://generation/metric/mse/mse_cpu.gd").new()

func calculate_fitness(
	individual: Individual,
	source_texture: RendererTexture) -> void:
		
	# Since the mse metric calculates the error, the "similarity" is the complement
	individual.fitness = 1.0 - mse_metric.compute(source_texture)

func _target_texture_set():
	mse_metric.target_texture = target_texture
