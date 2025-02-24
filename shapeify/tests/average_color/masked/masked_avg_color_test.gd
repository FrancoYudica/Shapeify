extends Control

@export var sub_viewport: SubViewport
@export var sprite_mask: Texture2D

@export var sampler_scripts: Array[GDScript]
var samplers: Array[AverageColorSampler] = []
@export var compare_results: bool

@onready var sample_color_rect := $OutlineColorRect/MarginContainer/SampleTextureRect
@onready var parent_color_rect := $OutlineColorRect

var local_sprite_mask: LocalTexture

func _ready() -> void:
	
	for sampler_script in sampler_scripts:
		samplers.append(sampler_script.new())

	var renderer := GenerationGlobals.renderer
	local_sprite_mask = LocalTexture.load_from_texture(sprite_mask, renderer.rd)


var _textures_initialized = false

func _process(delta: float) -> void:
	
	var renderer := GenerationGlobals.renderer
	var sub_viewport_texture = sub_viewport.get_texture()
	var sub_viewport_renderer_texture = LocalTexture.load_from_texture(sub_viewport_texture, renderer.rd)
	
	# Renders background only
	renderer.begin_frame(size)
	renderer.render_sprite(
		sub_viewport_renderer_texture.get_size() * 0.5,
		sub_viewport_renderer_texture.get_size(),
		0.0,
		Color.WHITE,
		sub_viewport_renderer_texture
	)
	renderer.end_frame()
	
	# Gets the clean sample texture
	if not _textures_initialized:
		var color_attachment = renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.COLOR)
		var texture = color_attachment.copy()
		for sampler in samplers:
			sampler.sample_texture = texture
	
	# Renders background and sprite with it's ID
	renderer.begin_frame(size)
	renderer.render_sprite(
		sub_viewport_renderer_texture.get_size() * 0.5,
		sub_viewport_renderer_texture.get_size(),
		0.0,
		Color.WHITE,
		sub_viewport_renderer_texture
	)
	
	var mouse = get_local_mouse_position()
	
	renderer.render_sprite(
		mouse,
		sample_color_rect.get_global_rect().size,
		0.0,
		Color.WHITE,
		local_sprite_mask,
		1.0
	)
	renderer.end_frame()

	# Gets the clean sample texture
	if not _textures_initialized:
		var id_texture = renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.UID)
		for sampler in samplers:
			sampler.id_texture = id_texture
		_textures_initialized = false

	var rect: Rect2i
	rect.position = Vector2i(mouse - sample_color_rect.get_global_rect().size * 0.5)
	rect.size = Vector2i(
		sample_color_rect.get_global_rect().size.x,
		sample_color_rect.get_global_rect().size.y)
	
	for sampler in samplers:
		var clock = Clock.new()
		var color = sampler.sample_rect(rect)
		clock.print_elapsed("Sampled average color: %s" % color)
		sample_color_rect.modulate = color
		
	parent_color_rect.position = rect.position
