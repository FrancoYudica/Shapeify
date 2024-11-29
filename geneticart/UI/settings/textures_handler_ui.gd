extends PanelContainer


@export var textures_ui_container: Control

var image_item_packed = preload("res://UI/settings/image_item.tscn")

## Maps image_item to RendererTexture
var _textures_map: Dictionary
var _populator_params: PopulatorParams

func _ready() -> void:
	_populator_params = Globals.settings.image_generator_params.individual_generator_params.populator_params
	
	# Adds the default textures
	for renderer_texture in _populator_params.textures:
		var texture = RenderingCommon.create_texture_from_rd_rid(renderer_texture.rd_rid)
		var image_item = image_item_packed.instantiate()
		_add_image_item(image_item, renderer_texture)
		image_item.texture = texture
		
	

func _on_image_loader_image_file_dropped(filepath: String) -> void:
	
	if not visible:
		return
	
	var image_item = image_item_packed.instantiate()
	
	# Creates a renderer texture and adds to pupupator params
	var renderer_texture = RendererTexture.load_from_path(filepath)
	_populator_params.textures.append(renderer_texture)
	_add_image_item(image_item, renderer_texture)
	image_item.filepath = filepath
	

func _add_image_item(image_item, renderer_texture):
	textures_ui_container.add_child(image_item)

	_textures_map[image_item] = renderer_texture

	# When removed, removes the texture from the params
	image_item.tree_exiting.connect(
		func():
			var texture: RendererTexture = _textures_map[image_item]
			_populator_params.textures.erase(texture)
	)
	
