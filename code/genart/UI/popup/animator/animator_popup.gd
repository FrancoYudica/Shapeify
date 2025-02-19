extends Control

signal shapes_animated(details: ImageGenerationDetails)
signal animation_progress_updated(t: float)
signal animation_started
signal animation_finished

@export var output_texture_panel_container: Control

var image_generation_details: ImageGenerationDetails:
	get:
		return ImageGeneration.details

var animation_player: ShapeAnimationPlayer

var _tween: Tween
var _current_t: float = 0.0
var duration: float = 5.0

func _ready() -> void:
	animation_player = ShapeAnimationPlayer.new()
	visibility_changed.connect(
		func():
			if visible:
				play_animation(0.0)
			else:
				stop()
	)

func play_animation(start_t: float):
	
	# Creates a local copy, since attributes get modified
	image_generation_details = ImageGeneration.details.copy()

	_tween = create_tween()
	var remaining = 1.0 - start_t
	_tween.tween_method(_interpolate, start_t, 1.0, remaining * duration)
	_tween.play()
	animation_started.emit()
	_tween.finished.connect(
		func():
			_current_t = 0.0
			animation_finished.emit()
	)


func _interpolate(t: float):

	# The viewport size is scaled to fit into the animator
	var src_size = image_generation_details.viewport_size
	var aspect_ratio = float(src_size.x) / src_size.y
	image_generation_details.viewport_size = Vector2i(
		output_texture_panel_container.size.y * aspect_ratio, 
		output_texture_panel_container.size.y)

	# Applies post processing
	var post_processed_details = await ShapeColorPostProcessingPipeline.process_details(
		image_generation_details,
		0,
		Globals.settings.color_post_processing_pipeline_params
	)

	# Animates current frame
	post_processed_details.shapes = animation_player.animate(
		post_processed_details.shapes, 
		t)
	shapes_animated.emit(post_processed_details)
	animation_progress_updated.emit(t)
	_current_t = t

func set_frame(t: float):
	stop()
	_interpolate(t)

func play():
	play_animation(_current_t)

func stop():
	if _tween != null and _tween.is_running():
		_tween.stop()
