extends PanelContainer

@export var metric_script: GDScript
@export var individual_count_value_label: Label
@export var current_execution_value_label: Label
@export var executions_count_value_label: Label
@export var time_taken_value_label: Label
@export var metric_score_label: Label
@export var close_button: Button
@export var weight_texture_rect: TextureRect
@export var output_texture_holder: Node
@export var image_generation: Node

var _metric: Metric
var _should_recalculate_metric: bool = false
var _clock: Clock

func _ready() -> void:
	_metric = metric_script.new() as Metric
	weight_texture_rect.visible = false
	
	close_button.pressed.connect(
		func():
			visible = false
	)
	
	image_generation.shape_generated.connect(
		func(i):
			_should_recalculate_metric = true
	)

	image_generation.generation_cleared.connect(
		func():
			_should_recalculate_metric = true
	)
	image_generation.generation_started.connect(
		func():
			_clock = Clock.new()
			weight_texture_rect.visible = true
	)
	
	image_generation.generation_finished.connect(
		func():
			_clock = null
			weight_texture_rect.visible = false
	)


func _process(delta: float) -> void:
	
	if not visible:
		return
		
		
	var details: ImageGenerationDetails = image_generation.image_generation_details
	individual_count_value_label.text = str(details.shapes.size())
	executions_count_value_label.text = str(details.executed_count)
	
	if _clock != null:
		current_execution_value_label.text = _ms_to_str(_clock.elapsed_ms())
		time_taken_value_label.text = _ms_to_str(details.time_taken_ms + _clock.elapsed_ms())
		
	else:
		time_taken_value_label.text = _ms_to_str(details.time_taken_ms)
	
	if _should_recalculate_metric:
		_metric.target_texture = Globals \
								.settings \
								.image_generator_params \
								.shape_generator_params \
								.target_texture
								
		var score = _metric.compute(output_texture_holder.renderer_texture)
		metric_score_label.text = "%.6f" % score
		_should_recalculate_metric = false
	
	weight_texture_rect.texture = output_texture_holder.weight_texture
	
func _ms_to_str(milliseconds: int) -> String:
	var seconds = (milliseconds / 1000) % 60  # Seconds part
	var ms = milliseconds % 1000  # Milliseconds part
	var minutes = milliseconds / 60000  # Total minutes

	if minutes > 0:
		return "%s min, %s sec, %s ms" % [minutes, seconds, ms]
	elif seconds > 0:
		return "%s sec, %s ms" % [seconds, ms]
	else:
		return "%s ms" % ms
