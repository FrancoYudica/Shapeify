class_name VideoRecorder extends RefCounted


var _frame_index: int = 0
var animations_dir: DirAccess

var video_folder_path = "res://out/animation"
var _current_folder: String
var _recording: bool = false

var _path_separator: String:
	get:
		if OS.get_name() == "Windows":
			return "\\"
		return "/"

func start_recording() -> bool:
	
	animations_dir = DirAccess.open(video_folder_path)
	
	if _recording:
		push_error("Trying to start record but it's already recording")
		return false
	
	_recording = true
	
	_frame_index = 0
	_current_folder = Time.get_datetime_string_from_system().replace(":", "_")
	var err = animations_dir.make_dir(_current_folder)
	if err != OK:
		Notifier.call_deferred("notify_error", "Unable to create video directory %s in path: %s" % [_current_folder, video_folder_path])
		return false
		
	return true

func add_frame(image: Image):

	if not _recording:
		push_error("Trying to record frames but it's not recording")
		return
	
	var path = iterator_next_path() + ".png"
	var err = image.save_png(path)
	if err != OK:
		print(err)

func iterator_next_path() -> String:
	var path = video_folder_path + _path_separator + _current_folder + _path_separator + "frame_%05d" % _frame_index
	_frame_index += 1
	return path

func finish_and_get_path() -> String:
	
	if not _recording:
		push_error("Trying to finish but it's not recording")
		return ""
	
	_recording = false
	
	return ProjectSettings.globalize_path(video_folder_path + _path_separator + _current_folder)
