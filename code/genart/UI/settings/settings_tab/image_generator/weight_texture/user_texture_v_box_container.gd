extends VBoxContainer

@export var _weight_texture_rect: TextureRect
@export var _load_texture_button: Button
@export var _image_file_dialog: FileDialog
@export var _texture_label: Label

var _params: ImageGeneratorParams:
	get:
		return Globals.settings.image_generator_params
						
func _ready() -> void:
	
	_load_texture_button.pressed.connect(
		func():
			_image_file_dialog.visible = true
	)
	
	_image_file_dialog.file_selected.connect(
		func(filepath):
				
			var renderer_texture := RendererTexture.load_from_path(filepath)
			
			if renderer_texture == null or not renderer_texture.is_valid():
				Notifier.notify_error("Unable to load texture")
				return
			
			_params.weight_texture_generator_params.user_weight_texture = renderer_texture
			_set_texture(renderer_texture)
	)
	
	Globals.image_generator_params_updated.connect(_update)
	_update()
	
func _exit_tree() -> void:
	_free_weight_texture()

func _process(delta: float) -> void:
	visible = _params.weight_texture_generator_type == WeightTextureGenerator.Type.USER
	_texture_label.visible = _params.weight_texture_generator_params.user_weight_texture == null

func _update():
	_set_texture(_params.weight_texture_generator_params.user_weight_texture)

func _set_texture(texture: RendererTexture):
	if texture == null:
		return
		
	_free_weight_texture()
	var texture_2d_rd = RenderingCommon.create_texture_from_rd_rid(texture.rd_rid)
	_weight_texture_rect.texture = texture_2d_rd

func _free_weight_texture():
	var previous_texture: Texture2DRD = _weight_texture_rect.texture
	
	if previous_texture != null:
		var rd = RenderingServer.get_rendering_device()
		var texture_rd_rid = previous_texture.texture_rd_rid
		previous_texture.texture_rd_rid = RID()
		previous_texture = null
		rd.free_rid(texture_rd_rid)
