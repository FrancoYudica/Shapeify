extends Control

@onready var texture_rect := $MarginContainer/VBoxContainer/TextureRect

func _on_image_loader_image_file_dropped(filepath: String) -> void:
	
	if not visible:
		return
	
	var image = Image.new()
	if image.load(filepath) != OK:
		printerr("Error while loading image from path")
		return
		
	var image_texture = ImageTexture.create_from_image(image)
	texture_rect.texture = image_texture
	
	
