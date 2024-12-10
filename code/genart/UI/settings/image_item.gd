extends PanelContainer

@onready var _label = $MarginContainer/VBoxContainer/Label
@onready var _texture_rect = $MarginContainer/VBoxContainer/TextureRect


var filepath: String:
	get:
		return _label.text
		
	set(value):
		var image = Image.new()
		
		if image.load(value) != OK:
			printerr("Error while loading filepath: %s" % value)
			return
		
		var image_texture = ImageTexture.create_from_image(image)
		_texture_rect.texture = image_texture
		var paths = value.rsplit("/")
		_label.text = paths[paths.size() - 1]

var texture: Texture:
	set(value):
		_texture_rect.texture = value
		_label.text = ""


func _on_delete_button_pressed() -> void:
	queue_free()
