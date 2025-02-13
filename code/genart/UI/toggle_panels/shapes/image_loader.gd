extends Node

@export var target_image_loader: Node

func _ready() -> void:
	get_tree().get_root().files_dropped.connect(on_files_dropped)

func on_files_dropped(files):
	target_image_loader.load_target_image_from_filepath(files[0])
