class_name AnimationVideoRecorder extends RefCounted

signal recorded(frames_path: String)

var fps: int = 60
var duration: float = 1.0
var directory_path: String
var frame_saver_type: FrameSaver.Type
var _video_recorder := VideoRecorder.new()
var _progress: float = 0.0

var _animation_player: IndividualAnimationPlayer
var _image_generation_details: ImageGenerationDetails
var _frame_saver: FrameSaver
var _render_scale: float

var progress: float:
	get:
		return _progress

func record(
	animation_player: IndividualAnimationPlayer,
	image_generation_details: ImageGenerationDetails,
	frame_saver_type: FrameSaver.Type,
	scale: float
):
	_animation_player = animation_player
	_image_generation_details = image_generation_details
	_frame_saver = FrameSaver.factory_create(frame_saver_type)
	_frame_saver.silent = true
	_render_scale = scale
	WorkerThreadPool.add_task(_record_and_save)

func _record_and_save():
	_progress = 0.0
	
	if not DirAccess.dir_exists_absolute(directory_path):
		push_error("Trying to save frames in non existing directory")
		return
	
	_video_recorder.video_folder_path = directory_path
	if not _video_recorder.start_recording():
		return
	
	var dt = 1.0 / (fps * duration)
	var t = 0.0
	
	while t < 1.0:
		
		# Gets frame individuals
		var frame_individuals := _animation_player.animate(
			_image_generation_details.individuals,
			_image_generation_details.viewport_size,
			t
		)
		
		# Gets path
		var path = _video_recorder.iterator_next_path() + _frame_saver.get_extension()
		
		# Saves frame with frame saver
		if not _frame_saver.save(
			path,
			frame_individuals,
			_image_generation_details.clear_color,
			_image_generation_details.viewport_size,
			_render_scale
		):
			return
		
		# Updates progress
		t += dt
		_progress = t
	
	_progress = 1.0
	
	var path = _video_recorder.finish_and_get_path()
	call_deferred("_emit_recorded_signal", path)
	
func _emit_recorded_signal(frames_path: String):
	recorded.emit(frames_path)
	Notifier.notify_info(
		"Frames saved at: %s" % frames_path,
		frames_path)
