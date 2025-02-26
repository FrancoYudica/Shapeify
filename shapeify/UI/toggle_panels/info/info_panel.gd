extends PanelContainer

@export var debug_texture_holders: Array[DebugTextureHolder] = []

@export var shape_count_value_label: Label
@export var time_taken_value_label: Label
@export var metric_score_label: Label
@export var similarity_score_label: Label
@export var processing_resolution_label: Label
@export var debug_textures_container: Control

var debug_texture_scene = load("res://UI/toggle_panels/info/debug_texture_panel_container.tscn")

var _generation_time_taken_clock: Clock
var _time_taken := 0.0

func _ready() -> void:
	
	ImageGeneration.shape_generated.connect(
		func(i):
			_update_metric_values()
	)

	ImageGeneration.generation_cleared.connect(
		func():
			_time_taken = 0.0
			_update_metric_values()
	)
	ImageGeneration.generation_started.connect(
		func():
			_generation_time_taken_clock = Clock.new()
	)
	
	ImageGeneration.generation_finished.connect(
		func():
			_time_taken += _generation_time_taken_clock.elapsed_ms()
			_generation_time_taken_clock = null
	)
	
	for debug_texture_holder in debug_texture_holders:
		var debug_texture = debug_texture_scene.instantiate()
		debug_texture.title = debug_texture_holder.texture_name
		debug_textures_container.add_child(debug_texture)


func _process(delta: float) -> void:
	
	if not is_visible_in_tree():
		return
		
	shape_count_value_label.text = str(ImageGeneration.master_renderer_params.shapes.size())
	
	var processing_resolution = ImageGeneration.image_processing_resolution
	processing_resolution_label.text = "%sx%s" % [
		int(processing_resolution.x), 
		int(processing_resolution.y)]
	
	if _generation_time_taken_clock != null:
		time_taken_value_label.text = _ms_to_str(_time_taken + _generation_time_taken_clock.elapsed_ms())
		
	else:
		time_taken_value_label.text = _ms_to_str(_time_taken)
	
	# Updates the textures of all the containers
	for i in range(debug_texture_holders.size()):
		var debug_texture = debug_textures_container.get_child(i)
		var debug_texture_holder = debug_texture_holders[i]
		debug_texture_holder.update_texture_rect(debug_texture.texture_rect)
	
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
