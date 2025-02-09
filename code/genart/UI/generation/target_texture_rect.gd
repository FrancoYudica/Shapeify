extends TextureRect

@export var image_generation: Node

var _image_generator_params: ImageGeneratorParams:
	get:
		return Globals.settings.image_generator_params 

func _ready() -> void:
	_update_target_texture()
	image_generation.target_texture_updated.connect(_target_texture_updated)

func _target_texture_updated() -> void:

	_free_texture()
	_update_target_texture()
	
func _free_texture():
	
	if texture == null:
		return
	
	var rd = RenderingServer.get_rendering_device()
	var texture_rd_rid = texture.texture_rd_rid
	texture.texture_rd_rid = RID()
	texture = null
	rd.free_rid(texture_rd_rid)


func _update_target_texture():
	
	var target_texture: RendererTexture = _image_generator_params.target_texture
	if target_texture == null or not target_texture.is_valid():
		Notifier.notify_error("Unable to update_target_texture() if target texture is null")
		return
	
	# Creates texture for the first time
	texture = RenderingCommon.create_texture_from_rd_rid(target_texture.rd_rid)
