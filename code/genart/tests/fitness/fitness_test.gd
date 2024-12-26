extends Node

@export var target_texture: RendererTextureLoad
@export var source_texture: RendererTextureLoad

@export var metric_scripts: Array[GDScript]
@export var iterations = 10
@export var individual: Individual

func _ready() -> void:
	
	
	for script in metric_scripts:
	
		var average_error = 0.0
		var average_time = 0.0
		var f = 1.0 / iterations
		var fitness_calculator: FitnessCalculator = script.new()
		var t0 = Time.get_ticks_msec()
		fitness_calculator.target_texture = target_texture
		
		for i in range(iterations):
			
			var t = Time.get_ticks_msec()
			fitness_calculator.calculate_fitness(individual, source_texture)
			average_error += f * individual.fitness
			var elapsed_t = Time.get_ticks_msec() - t
			average_time += f * elapsed_t
		
		print(" Executed %s iterations of Metric: %s" % [iterations, script.resource_path])
		print(" - Average: %s" % average_error)
		print(" - Average compute time taken: %sms " % average_time)
		print(" - Total time taken: %sms " % (Time.get_ticks_msec() - t0))
		print()
