extends Node2D

@export var metric_scripts: Array[GDScript]
@export var target_texture: RendererTextureLoad
@export var source_texture: RendererTextureLoad
@export var individual: Individual
@export var iterations: int = 10
var _partial_metrics: Array[PartialMetric]

var _individual_renderer := IndividualRenderer.new()

func _ready() -> void:
	
	# Initializes PartialMetrics and setups attributes
	_individual_renderer.source_texture = source_texture
	_individual_renderer.render_individual(individual)
	var new_source_texutre = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR).copy()
	
	for script in metric_scripts:
		var partial_metric: PartialMetric = script.new()
		partial_metric.target_texture = target_texture
		partial_metric.source_texture = source_texture
		partial_metric.new_source_texture = new_source_texutre
		_partial_metrics.append(partial_metric)
	
	# Evaluates results
	var f = 1.0 / iterations
	
	for metric in _partial_metrics:
		var average_error: float = 0.0
		var average_time: float = 0.0
		for i in range(iterations):
			
			var t = Time.get_ticks_usec()
			var value = metric.compute(individual.get_bounding_rect())
			var elapsed_t = (Time.get_ticks_usec() - t) * 0.001
			print("Elapsed: %s. Result: %s" % [elapsed_t, value])

			average_error += f * value
			average_time += f * elapsed_t
		
		print(" - Average: %s" % average_error)
		print(" - Average compute time taken: %sms " % average_time)
		print()
