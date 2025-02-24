extends Node2D

@onready var output_texture_rect := $CanvasLayer/OutputTextureRect
@onready var sprites_container := $Node2D

var local_renderer: LocalRenderer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	local_renderer = LocalRenderer.new()
	local_renderer.initialize(
		LocalRenderer.Type.SPRITE,
		RenderingServer.get_rendering_device()
	)
	
func _process(delta: float) -> void:
	
	# Transforms all the sprite textures to local textures
	var texture_map = {}
	for sprite: Sprite2D in sprites_container.get_children():
		texture_map[sprite.texture.get_rid()] = LocalTexture.load_from_texture(sprite.texture, local_renderer.rd)
	
	var clock := Clock.new()
	
	local_renderer.begin_frame(output_texture_rect.size)
	local_renderer.render_clear(Color.BLUE)
	
	for sprite in sprites_container.get_children():
		var texture = texture_map[sprite.texture.get_rid()]
		var sprite_size = texture.get_size() * sprite.scale
		local_renderer.render_sprite(
			sprite.position,
			sprite_size,
			sprite.rotation,
			sprite.modulate,
			texture,
			0
		)
	
	local_renderer.end_frame()
	clock.print_elapsed("Rendered")
	
	clock.restart()
	var color_attachment = local_renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.COLOR)
	output_texture_rect.texture = color_attachment.create_texture_2d_rd()
	clock.print_elapsed("Texture copied")
	
