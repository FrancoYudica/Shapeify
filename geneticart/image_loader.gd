extends Node

signal image_file_dropped(filepath: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().get_root().files_dropped.connect(on_files_dropped)

func on_files_dropped(files):
	
	for file: String in files:
		
		var valid_file = file.ends_with(".png") or file.ends_with(".jpg")
		
		if valid_file:
			image_file_dropped.emit(file)
