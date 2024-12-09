class_name AnimationVideoRecorder extends RefCounted

signal recorded(frames_path: String)

var fps: int = 60
var duration: float = 1.0

var _video_recorder := VideoRecorder.new()
var _animation_renderer := AnimationRenderer.new()

func record(
	animation_player: IndividualAnimationPlayer,
	image_generation_details: ImageGenerationDetails
):
	_animation_renderer.animation_player = animation_player
	_animation_renderer.image_generation_details = image_generation_details
	WorkerThreadPool.add_task(_record_and_save)

func _record_and_save():
	_video_recorder.start_recording()
	
	var dt = 1.0 / (fps * duration)
	var t = 0.0
	
	while t < 1.0:
		var img := _animation_renderer.render_frame(t)
		_video_recorder.add_frame(img)
		t += dt
		
	var path = _video_recorder.finish_and_get_path()
	call_deferred("_emit_recorded_signal", path)
	
func _emit_recorded_signal(frames_path: String):
	recorded.emit(frames_path)
