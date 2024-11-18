extends CanvasLayer

@export var textures_ui_container: Control

func get_images() -> Array:
	var textures = []
	for image_item in textures_ui_container.get_children():
		textures.append(image_item.image)
	
	return textures
	
