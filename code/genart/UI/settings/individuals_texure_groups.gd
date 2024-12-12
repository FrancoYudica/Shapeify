extends Control

signal selected_texture_group(texture_group: IndividualsTextureGroup)

@export var group_item_container: Container

func _ready() -> void:
	
	var texture_group_item_packed = load("res://UI/settings/texture_group_item.tscn")
	
	var texture_groups = Globals.settings.individuals_texture_groups
	for group in texture_groups:
		var item = texture_group_item_packed.instantiate()
		item.texture_group = group
		item.selected.connect(_selected_group)
		group_item_container.add_child(item)
		

func _selected_group(group: IndividualsTextureGroup) -> void:
	selected_texture_group.emit(group)
	visible = false

func _on_close_button_pressed() -> void:
	visible = false
