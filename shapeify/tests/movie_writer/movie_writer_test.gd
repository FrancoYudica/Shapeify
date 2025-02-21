extends Node2D

@export var sub_viewport: SubViewport

var _video_recorder := VideoRecorder.new()

func _ready() -> void:
	_video_recorder.start_recording()

func _on_button_pressed() -> void:
	var frame = sub_viewport.get_texture().get_image()
	_video_recorder.add_frame(frame)


func _on_save_button_pressed() -> void:
	print(_video_recorder.finish_and_get_path())
	_video_recorder.start_recording()
