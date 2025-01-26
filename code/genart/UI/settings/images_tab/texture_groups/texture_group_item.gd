extends PanelContainer

signal selected(group: ShapeTextureGroup)

@export var textures_container: Container
@export var title_label: Label

var texture_group: ShapeTextureGroup


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	title_label.text = texture_group.name
	
	for texture in texture_group.textures:
		var texture_rect := TextureRect.new()
		texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texture_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
		texture_rect.texture = texture
		textures_container.add_child(texture_rect)

func _on_button_pressed() -> void:
	selected.emit(texture_group)
