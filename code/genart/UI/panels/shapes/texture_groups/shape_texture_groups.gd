extends Control

signal selected_texture_group(texture_group: ShapeTextureGroup)

@export var group_item_container: Container

func _ready() -> void:
	
	var texture_group_item_packed = load("res://UI/panels/shapes/texture_groups/texture_group_item.tscn")
	
	var texture_groups = Globals.settings.shape_texture_groups
	for group in texture_groups:
		var item = texture_group_item_packed.instantiate()
		item.texture_group = group
		item.selected.connect(_selected_group)
		group_item_container.add_child(item)
		

func _selected_group(group: ShapeTextureGroup) -> void:
	selected_texture_group.emit(group)
	visible = false

func _on_close_button_pressed() -> void:
	visible = false
