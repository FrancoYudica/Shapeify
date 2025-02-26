extends Control

signal shapes_animated(shapes: Array[Shape])
signal animation_progress_updated(t: float)
signal animation_started
signal animation_finished

@export var output_texture_panel_container: Control

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
	# Animates current frame
	var post_processed_params = MasterRenderer.apply_post_processing(ImageGeneration.master_renderer_params)
	var animated_shapes = animation_player.animate(post_processed_params.shapes, t)
	shapes_animated.emit(animated_shapes)
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
