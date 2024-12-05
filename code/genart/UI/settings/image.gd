extends Control

@export var textures_ui_container: Control

var image_item_packed = preload("res://UI/image_item.tscn")

func _on_image_loader_image_file_dropped(filepath: String) -> void:
	
	if not visible:
		return
	
	var image_item = image_item_packed.instantiate()
	textures_ui_container.add_child(image_item)
	image_item.filepath = filepath
