extends Button

@export var image_loader_dialog: FileDialog
@export var target_image_loader: Node

func _ready() -> void:
	pressed.connect(image_loader_dialog.show)
	image_loader_dialog.file_selected.connect(target_image_loader.load_target_image_from_filepath)
