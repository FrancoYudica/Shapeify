extends PanelContainer

@export var output_texture_holder: Node

@export var shape_count_value_label: Label
@export var current_execution_value_label: Label
@export var executions_count_value_label: Label
@export var time_taken_value_label: Label
@export var metric_score_label: Label
@export var similarity_score_label: Label
@export var weight_texture_rect: TextureRect

var _clock: Clock

func _ready() -> void:
	weight_texture_rect.visible = false
	
	Globals.shape_generated.connect(
		func(i):
			_update_metric_values()
	)

	Globals.generation_cleared.connect(
		func():
			_update_metric_values()
	)
	Globals.generation_started.connect(
		func():
			_clock = Clock.new()
			weight_texture_rect.visible = true
	)
	
	Globals.generation_finished.connect(
		func():
			_clock = null
			weight_texture_rect.visible = false
	)


func _process(delta: float) -> void:
	
	if not visible:
		return
		
	var details: ImageGenerationDetails = ImageGeneration.details
	shape_count_value_label.text = str(details.shapes.size())
	executions_count_value_label.text = str(details.executed_count)
	
	if _clock != null:
		current_execution_value_label.text = _ms_to_str(_clock.elapsed_ms())
		time_taken_value_label.text = _ms_to_str(details.time_taken_ms + _clock.elapsed_ms())
		
	else:
		time_taken_value_label.text = _ms_to_str(details.time_taken_ms)
	
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

func _update_metric_values():
	metric_score_label.text = "%.6f" % ImageGeneration.image_generator.metric_value
	similarity_score_label.text = "%.6f" % ImageGeneration.image_generator.similarity
