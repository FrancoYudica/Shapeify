extends PanelContainer

@export var _label: Label
@export var texture_rect: TextureRect

var title: String:
	set(value):
		_label.text = value
		
var texture: Texture2D:
	set(value):
		texture_rect.texture = value
