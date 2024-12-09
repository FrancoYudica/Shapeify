class_name VideoRecorder extends RefCounted


var _frame_index: int = 0
var animations_dir: DirAccess

var video_folder_path = "res://out/animation"
var _current_folder: String
var _recording: bool = false

func start_recording():
	
	animations_dir = DirAccess.open(video_folder_path)
	
	if _recording:
		push_error("Trying to start record but it's already recording")
		return
	
	_recording = true
	
	_frame_index = 0
	_current_folder = Time.get_datetime_string_from_system()
	var err = animations_dir.make_dir(_current_folder)
	if err != OK:
		push_error("Unable to create video directory %s" % _current_folder)

func add_frame(image: Image):

	if not _recording:
		push_error("Trying to record frames but it's not recording")
		return

	image.save_png(video_folder_path + "/" + _current_folder + "/frame_%05d.png" % _frame_index)
	_frame_index += 1

func finish_and_get_path() -> String:
	
	if not _recording:
		push_error("Trying to finish but it's not recording")
		return ""
	
	_recording = false
	
	return ProjectSettings.globalize_path(video_folder_path + "/" + _current_folder)
