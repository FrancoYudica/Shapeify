extends VBoxContainer

@export var target_metric_value_spin: SpinBox
@export var metric_type_option: OptionButton

var _params : ImageGeneratorParams:
	get:
		return Globals.settings.image_generator_params

var _metric_type_indices: Array = [
	Metric.Type.DELTA_E_1976,
	Metric.Type.DELTA_E_1994
]

func _ready() -> void:
	target_metric_value_spin.value_changed.connect(
		func(value):
			_params.stop_condition_params.target_fitness = value
	)
	
	for type_index in _metric_type_indices:
		metric_type_option.add_item(Metric.Type.keys()[type_index])
	
	metric_type_option.item_selected.connect(
		func(index):
			_params.stop_condition_params.metric_type = _metric_type_indices[index]
	)
	
	Globals.image_generator_params_updated.connect(_update)
	_update()
	
func _update():
	target_metric_value_spin.value = _params.stop_condition_params.target_fitness
	
	for i in range(_metric_type_indices.size()):
		var metric_type_index = _metric_type_indices[i]
		if metric_type_index == _params.stop_condition_params.metric_type:
			metric_type_option.select(i)

func _process(delta: float) -> void:
	visible = _params.stop_condition == StopCondition.Type.METRIC_VALUE
