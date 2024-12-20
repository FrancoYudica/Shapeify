extends TextureButton

@export var animator: Node
@export var recording_panel: Control
@export var file_dialog: FileDialog
@export var progress_bar: ProgressBar

var _animation_recorder := AnimationVideoRecorder.new()

func _ready() -> void:
	
	_animation_recorder.recorded.connect(
		func(saved_path: String):
			Notifier.notify_info("Frames saved at: %s" % saved_path)
			recording_panel.visible = false
	)
	
	pressed.connect(
		func():
			file_dialog.visible = true
	)

func _process(delta: float) -> void:
	progress_bar.value = _animation_recorder.progress

func _on_file_dialog_dir_selected(dir: String) -> void:
	_animation_recorder.directory_path = dir
	_begin_recording()

func _begin_recording():
	animator.stop()
	_animation_recorder.duration = animator.duration
	_animation_recorder.record(
		animator.animation_player,
		animator.image_generation_details
	)
	recording_panel.visible = true
