class_name MasterRendererOutput extends PanelContainer

signal master_renderer_params_set

@export var texture_rect: TextureRect
@export var aspect_ratio_conatiner: AspectRatioContainer

## Uses a local renderer so that rendering process doesn't interfere with
## the image generation algorithm
var _local_renderer: LocalRenderer

## If the current output is invalidated, the output texture must be rendered again
var _invalidated = false

var master_renderer_params: MasterRendererParams:
	set(value):
		
		if value != master_renderer_params:
			master_renderer_params = value
			master_renderer_params.changed.connect(invalidate)
			invalidate()
			master_renderer_params_set.emit()

func _ready() -> void:
	
	# Creates local renderer
	_local_renderer = LocalRenderer.new()
	
	# Uses the global rendering device. This way the texture update is faster
	_local_renderer.initialize(RenderingServer.get_rendering_device())
	
	# Connects signals
	texture_rect.resized.connect(invalidate)
	visibility_changed.connect(
		func():
			if is_visible_in_tree():
				invalidate())
	RenderingServer.frame_pre_draw.connect(
		func():
			if _invalidated:
				_render()
				_present()
				_invalidated = false)
	
# Returns mouse position relative to the top left of the texture rect
func _get_local_mouse_position():
	return texture_rect.get_local_mouse_position()

func _exit_tree() -> void:
	_local_renderer.delete()
	_local_renderer = null

func invalidate():
	_invalidated = true
	
func _render():
	
	if master_renderer_params == null or not is_visible_in_tree():
		return
	
	var target_texture = Globals.settings.image_generator_params.target_texture
	var aspect_ratio = float(target_texture.get_width()) / target_texture.get_height()
	aspect_ratio_conatiner.ratio = aspect_ratio
	MasterRenderer.render(_local_renderer, texture_rect.size, master_renderer_params)


var _previous_color_attachment: LocalTexture

func _present():
	# Copies textures contents into TextureRect's texture
	var color_attachment = _local_renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.COLOR)
	
	if not color_attachment.is_valid():
		return
	
	if texture_rect.texture == null:
		texture_rect.texture = Texture2DRD.new()
		
	texture_rect.texture.texture_rd_rid = color_attachment.rd_rid
	
	# Stores a reference to the color attachment. This is necessary since if the renderer
	# resizes, the previous framebuffer color attachment gets removed and the output texture
	# becomes white.
	_previous_color_attachment = color_attachment
