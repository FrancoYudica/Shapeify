extends Node

signal image_file_dropped(filepath: String)

@export var image_generation: Node

var _generating := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().get_root().files_dropped.connect(on_files_dropped)
	image_generation.generation_started.connect(
		func():
			_generating = true
	)
	image_generation.generation_finished.connect(
		func():
			_generating = false
	)

func on_files_dropped(files):
	
	if _generating:
		Notifier.notify_warning("Unable to drop image during image generation process")
		return
	
	for file: String in files:
		
		var valid_file = file.to_lower().ends_with(".png") or file.to_lower().ends_with(".jpg") or file.to_lower().ends_with(".jpeg")
		print(valid_file)
		
		if valid_file:
			image_file_dropped.emit(file)
