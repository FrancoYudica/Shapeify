extends Node2D

@export var partial_metric_script: GDScript
@export var metric_script: GDScript
@export var target_texture: RendererTextureLoad
@export var source_texture: RendererTextureLoad
@export var shape: Shape
@export var iterations: int = 10
@export var weight_texture_type: WeightTextureGenerator.Type
var _partial_metric: PartialMetric
var _metric: Metric

var _shape_renderer := ShapeRenderer.new()

@onready var _weight_texture_generator := WeightTextureGenerator.factory_create(weight_texture_type)

func _ready() -> void:
	
	# Initializes PartialMetrics and setups attributes
	_shape_renderer.source_texture = source_texture
	_shape_renderer.render_shape(shape)
	var new_source_texutre = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR).copy()
	
	_partial_metric = partial_metric_script.new()
	_partial_metric.target_texture = target_texture
	_partial_metric.source_texture = source_texture
	_partial_metric.new_source_texture = new_source_texutre
	_partial_metric.weight_texture = _weight_texture_generator.generate(0, target_texture)
	_metric = metric_script.new()
	_metric.target_texture = target_texture
	
	# Evaluates results
	var f = 1.0 / iterations
	
	var partial_metric_average_error: float = 0.0
	var partial_metric_average_time: float = 0.0
	var metric_average_error: float = 0.0
	var metric_average_time: float = 0.0
	for i in range(iterations):
	
		var t = Time.get_ticks_usec()
		var partial_metric_value = _partial_metric.compute(shape.get_bounding_rect())
		var elapsed_t = (Time.get_ticks_usec() - t) * 0.001
		print("Partial metric took: %sms. Result: %s" % [elapsed_t, partial_metric_value])

		partial_metric_average_error += f * partial_metric_value
		partial_metric_average_time += f * elapsed_t

		t = Time.get_ticks_usec()
		var metric_value = _metric.compute(new_source_texutre)
		elapsed_t = (Time.get_ticks_usec() - t) * 0.001
		print("Metric took: %sms. Result: %s" % [elapsed_t, metric_value])
		metric_average_time += f * elapsed_t
		metric_average_error += f * metric_value
		
	print(" - Average partial metric: %s" % partial_metric_average_error)
	print(" - Average metric: %s" % metric_average_error)
	print(" - Average partial metric compute time taken: %sms " % partial_metric_average_time)
	print(" - Average metric compute time taken: %sms " % metric_average_time)
	print()
