extends PanelContainer

@export var image_file_dialog: FileDialog

@export var texture_group_selector: Control
@export var textures_ui_container: Control

var image_item_packed = preload("res://UI/panels/shapes/image_items/image_item.tscn")

## Maps image_item to RendererTexture
var _textures_map: Dictionary

var _shape_spawner_params: ShapeSpawnerParams:
	get:
		return Globals.settings.image_generator_params.shape_generator_params.shape_spawner_params

func _ready() -> void:
	texture_group_selector.selected_texture_group.connect(_load_texture_group)
	
	# Adds the default textures
	for renderer_texture in _shape_spawner_params.textures:
		
		if not renderer_texture.is_valid():
			continue
		
		var texture = RenderingCommon.create_texture_from_rd_rid(renderer_texture.rd_rid)
		var image_item = image_item_packed.instantiate()
		_add_image_item(image_item, renderer_texture)
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
	var renderer_texture = RendererTexture.load_from_path(filepath)
	if renderer_texture == null:
		Notifier.notify_error("Dropped texture is null. File format not supported")
		return
	
	_shape_spawner_params.textures.append(renderer_texture)
	var image_item = image_item_packed.instantiate()
	_add_image_item(image_item, renderer_texture)
	image_item.filepath = filepath
	

func _add_image_item(image_item, renderer_texture):
	textures_ui_container.add_child(image_item)

	_textures_map[image_item] = renderer_texture

	# When removed, removes the texture from the params
	image_item.tree_exiting.connect(
		func():
			var texture: RendererTexture = _textures_map[image_item]
			_shape_spawner_params.textures.erase(texture)
	)

func _delete_all_images() -> void:
	
	for child in textures_ui_container.get_children():
		child.queue_free()


func _load_texture_group(group: ShapeTextureGroup) -> void:
	
	for texture in group.textures:
		var renderer_texture := RendererTexture.load_from_texture(texture)
		_shape_spawner_params.textures.append(renderer_texture)
		var image_item = image_item_packed.instantiate()
		_add_image_item(image_item, renderer_texture)
		image_item.texture = texture
	
func _on_delete_presets_button_pressed() -> void:
	_delete_all_images()

func _on_add_preset_button_pressed() -> void:
	texture_group_selector.visible = true


func _on_upload_images_button_pressed() -> void:
	image_file_dialog.visible = true
