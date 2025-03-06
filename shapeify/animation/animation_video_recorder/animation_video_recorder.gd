class_name AnimationVideoRecorder extends RefCounted

signal recorded(frames_path: String)

var fps: int = 60
var duration: float = 1.0
var directory_path: String
var frame_saver_type: FrameSaver.Type
var _video_recorder := VideoRecorder.new()
var _progress: float = 0.0

var _animation_player: ShapeAnimationPlayer
var _master_renderer_params: MasterRendererParams
var _frame_saver: FrameSaver
var _viewport_resolution: Vector2
var _local_renderer: LocalRenderer

var progress: float:
	get:
		return _progress

func _init() -> void:
	
	# Uses local renderer to render on a separate thread
	_local_renderer = LocalRenderer.new()
	_local_renderer.initialize(RenderingServer.create_local_rendering_device())
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		_local_renderer.delete()
		_local_renderer = null

func record(
	animation_player: ShapeAnimationPlayer,
	master_renderer_params: MasterRendererParams,
	viewport_resolution: Vector2i,
	frame_saver_type: FrameSaver.Type
):
	_animation_player = animation_player
	_master_renderer_params = master_renderer_params
	_viewport_resolution = viewport_resolution
	_frame_saver = FrameSaver.factory_create(frame_saver_type)
	_frame_saver.silent = true
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
		
		# Applies post processing before animating
		var post_processed_shapes = ShapeColorPostProcessingPipeline.execute_pipeline(
			_master_renderer_params.shapes, t, _master_renderer_params.post_processing_pipeline_params)
		
		var clear_color = ShapeColorPostProcessingPipeline.compute_clear_color(
			_master_renderer_params.clear_color, 0, _master_renderer_params.post_processing_pipeline_params)
		
		# Gets frame shapes
		var frame_shapes := _animation_player.animate(post_processed_shapes, t)
		
		# Gets path
		var path = _video_recorder.iterator_next_path() + _frame_saver.get_extension()
		
		# Creates renderer params with the animated shapes
		var animated_master_params = _master_renderer_params.duplicate()
		animated_master_params.shapes = frame_shapes
		animated_master_params.clear_color = clear_color
		animated_master_params.post_processing_pipeline_params = null
		
		# Saves frame with frame saver
		if not _frame_saver.save(
			path, 
			_local_renderer,
			animated_master_params, 
			_viewport_resolution):
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
