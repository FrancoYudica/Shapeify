extends Node2D

@export var partial_metric_script: GDScript
@export var metric_script: GDScript
@export var target_texture: Texture2D
@export var source_texture: Texture2D
@export var shape: Shape
@export var iterations: int = 10
@export var weight_texture_type: WeightTextureGenerator.Type
var _partial_metric: PartialMetric
var _metric: Metric

var _shape_renderer := ShapeRenderer.new()

@onready var _weight_texture_generator := WeightTextureGenerator.factory_create(weight_texture_type)

@onready var _local_target_texture := LocalTexture.load_from_texture(target_texture, GenerationGlobals.renderer.rd)
@onready var _local_source_texture := LocalTexture.load_from_texture(source_texture, GenerationGlobals.renderer.rd)

func _ready() -> void:
	
	# Initializes PartialMetrics and setups attributes
	var renderer := GenerationGlobals.renderer
	ShapeRenderer.render_shape(
		renderer,
		_local_source_texture,
		shape
	)
	
	var new_source_texutre = renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.COLOR).copy()
	var weight_texture = _weight_texture_generator.generate(0, _local_target_texture, _local_source_texture)
	
	_partial_metric = partial_metric_script.new()
	_partial_metric.power = 4.0
	_partial_metric.target_texture = _local_target_texture
	_partial_metric.source_texture = _local_source_texture
	_partial_metric.new_source_texture = new_source_texutre
	_partial_metric.weight_texture = weight_texture
	
	_metric = metric_script.new()
	_metric.power = 4.0
	_metric.target_texture = _local_target_texture
	_metric.weight_texture = weight_texture
	
	# Evaluates results
	var f = 1.0 / iterations
	
	var partial_metric_average_error: float = 0.0
	var partial_metric_average_time: float = 0.0
	var metric_average_error: float = 0.0
	var metric_average_time: float = 0.0
	for i in range(iterations):
	
		var t = Time.get_ticks_usec()
	
		# Maps normalized bounding rect to canvas bounding rect
		var normalized_bounding_rect = shape.get_bounding_rect()
		var bounding_rect = Rect2i(
			normalized_bounding_rect.position.x * source_texture.get_width(),
			normalized_bounding_rect.position.y * source_texture.get_height(),
			max(1.0, normalized_bounding_rect.size.x * source_texture.get_width()),
			max(1.0, normalized_bounding_rect.size.y * source_texture.get_height())
		)
		var partial_metric_value = _partial_metric.compute(bounding_rect)
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
