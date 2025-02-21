## This stop condition uses only DeltaE metric to stop the algorithm.
extends StopCondition

var _current_metric_value := 0.0
var _target_metric_value := 0.0

var _metric: DeltaEMetric
var _weight_texture_generator: WeightTextureGenerator

func began_generating():
	_current_metric_value = 100.0
	
func shape_generated(
	source_texture: RendererTexture,
	target_texture: RendererTexture,
	shape: Shape):
		
	_metric.weight_texture = _weight_texture_generator.generate(0, target_texture, source_texture)
	_metric.target_texture = target_texture
	_current_metric_value = _metric.compute(source_texture)
	
func should_stop() -> bool:
	return _target_metric_value >= _current_metric_value

func get_progress() -> float:
	var delta_metric = clampf(_current_metric_value - _target_metric_value, 0.0, 100.0) * 0.01
	return 1.0 - delta_metric

func set_params(params: StopConditionParams) -> void:
	_target_metric_value = params.target_fitness
	_metric = Metric.factory_create(params.metric_type)
	
	# The texture generator is white
	_weight_texture_generator = WeightTextureGenerator.factory_create(WeightTextureGenerator.Type.WHITE)
