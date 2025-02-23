extends PanelContainer

@export var image_file_dialog: FileDialog

@export var texture_group_selector: Control
@export var textures_ui_container: Control

var image_item_packed = preload("res://UI/toggle_panels/shapes/image_items/image_item.tscn")


var _shape_spawner_params: ShapeSpawnerParams:
	get:
		return Globals.settings.image_generator_params.shape_generator_params.shape_spawner_params

func _ready() -> void:
	texture_group_selector.selected_texture_group.connect(_load_texture_group)
	
	# Adds the default textures
	for texture in _shape_spawner_params.textures:
		var image_item = image_item_packed.instantiate()
		_add_image_item(image_item, texture)
		image_item.texture = texture
	
	
	image_file_dialog.files_selected.connect(
		func(paths: PackedStringArray):
			for path in paths:
				_load_image(path)
	)
	
func _load_image(filepath: String) -> void:
	
	if not is_visible_in_tree():
		return
	
	# Creates a renderer texture and adds to pupupator params
	var image = Image.load_from_file(filepath)
	var image_texture := ImageTexture.create_from_image(image)
	if image_texture == null:
		Notifier.notify_error("Dropped texture is null. File format not supported")
		return
	
	_shape_spawner_params.textures.append(image_texture)
	var image_item = image_item_packed.instantiate()
	_add_image_item(image_item, image_texture)
	image_item.filepath = filepath
	

func _add_image_item(image_item, texture):
	textures_ui_container.add_child(image_item)

	# When removed, removes the texture from the params
	image_item.tree_exiting.connect(
		func():
			_shape_spawner_params.textures.erase(texture)
	)

func _delete_all_images() -> void:
	
	for child in textures_ui_container.get_children():
		child.queue_free()

func _load_texture_group(group: ShapeTextureGroup) -> void:
	
	for texture in group.textures:
		_shape_spawner_params.textures.append(texture)
		var image_item = image_item_packed.instantiate()
		_add_image_item(image_item, texture)
		image_item.texture = texture
	
func _on_delete_presets_button_pressed() -> void:
	_delete_all_images()

func _on_add_preset_button_pressed() -> void:
	texture_group_selector.visible = true

func _on_upload_images_button_pressed() -> void:
	image_file_dialog.visible = true
