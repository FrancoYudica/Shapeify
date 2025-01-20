extends StopCondition

var _generated_count: int = 0
var _stop_count: int = 10

func began_generating():
	_generated_count = 0

func individual_generated(
	source_texture: RendererTexture,
	target_texture: RendererTexture,
	individual: Individual):
	_generated_count += 1
	
func should_stop() -> bool:
	return _generated_count >= _stop_count

func get_progress() -> float:
	return float(_generated_count) / _stop_count

func get_process_number() -> int:
	return _generated_count

func set_params(params: StopConditionParams) -> void:
	_stop_count = params.individual_count
