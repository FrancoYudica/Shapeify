extends PanelContainer

@onready var _label = $VBoxContainer/Label
@onready var _texture_rect = $VBoxContainer/TextureRect

var image: Image

var filepath: String:
	get:
		return _label.text
		
	set(value):
		image = Image.new()
		
		if image.load(value) != OK:
			printerr("Error while loading filepath: %s" % value)
			return
		
		var image_texture = ImageTexture.create_from_image(image)
		
		_texture_rect.texture = image_texture
		var paths = value.rsplit("/")
		_label.text = paths[paths.size() - 1]


func _on_delete_button_pressed() -> void:
	queue_free()
