extends PanelContainer

signal master_renderer_params_set

@export var texture_rect: TextureRect
@export var aspect_ratio_container: AspectRatioContainer


var master_renderer_params: MasterRendererParams:
	set(value):
		
		if value != master_renderer_params:
			master_renderer_params = value
			master_renderer_params.changed.connect(invalidate)
			invalidate()
			master_renderer_params_set.emit() 

var _local_renderer: LocalRenderer

var _invalidated := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_local_renderer = LocalRenderer.new()
	_local_renderer.initialize(RenderingServer.get_rendering_device())

	RenderingServer.frame_pre_draw.connect(
		func():
			if _invalidated:
				_render()
				_invalidated = false)
	ImageGeneration.target_texture_updated.connect(invalidate)
	master_renderer_params = ImageGeneration.master_renderer_params

func invalidate():
	_invalidated = true

var _previous_color_attachment: LocalTexture

func _render():
	
	if not is_visible_in_tree():
		return
	
	var target_texture = Globals.settings.image_generator_params.target_texture
	var aspect_ratio = float(target_texture.get_width()) / target_texture.get_height()
	aspect_ratio_container.ratio = aspect_ratio
	
	var translation = texture_rect.size * master_renderer_params.camera_view_params.normalized_translation
	
	_local_renderer.begin_frame(
		texture_rect.size,
		master_renderer_params.camera_view_params.zoom,
		translation)

	_local_renderer.render_clear(master_renderer_params.clear_color)
	
	_local_renderer.render_sprite(
		texture_rect.size * 0.5,
		texture_rect.size,
		0.0,
		Color.WHITE,
		target_texture,
		0.0)
	
	_local_renderer.end_frame()
	
	
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
