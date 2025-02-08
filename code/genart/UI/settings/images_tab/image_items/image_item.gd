extends PanelContainer

@export var _texture_rect: TextureRect 

var filepath: String:
	set(value):
		var image = Image.new()
		
		if image.load(value) != OK:
			printerr("Error while loading filepath: %s" % value)
			return
		
		var image_texture = ImageTexture.create_from_image(image)
		_texture_rect.texture = image_texture

var texture: Texture:
	set(value):
		_texture_rect.texture = value

func _on_remove_button_pressed() -> void:
	queue_free()
