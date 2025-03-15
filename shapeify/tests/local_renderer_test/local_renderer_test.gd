extends Node2D

@onready var output_texture_rect := $CanvasLayer/OutputTextureRect
@onready var sprites_container := $Node2D

var local_renderer: LocalRenderer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	local_renderer = LocalRenderer.new()
	local_renderer.initialize(RenderingServer.get_rendering_device())
	
	

var _offset = Vector2.ZERO
var _zoom: float = 1.0
var _is_mouse_down = false
var _click_position = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_apply_zoom(event.factor)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_apply_zoom(-event.factor)
		
		if event.button_index == MOUSE_BUTTON_LEFT:
			_is_mouse_down = event.pressed
			if _is_mouse_down:
				_click_position = get_global_mouse_position()
			else:
				var mouse_delta = get_global_mouse_position() - _click_position
				_offset -= mouse_delta / _zoom
			
func _apply_zoom(factor):
	var zoom_delta = factor * 0.1
	var new_zoom = max(0.01, _zoom + _zoom * zoom_delta)

	# Get mouse position in world coordinates BEFORE zooming
	var mouse_world_before = _offset + (get_global_mouse_position() / _zoom)

	# Apply zoom
	_zoom = new_zoom

	# Get mouse position in world coordinates AFTER zooming
	var mouse_world_after = _offset + (get_global_mouse_position() / _zoom)

	# Adjust offset so that the mouse stays in place
	_offset += mouse_world_before - mouse_world_after


func _process(delta: float) -> void:
	
	var offset_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()
	_offset += delta * offset_dir * 100
	
	var mouse_delta = Vector2.ZERO
	
	if _is_mouse_down:
		mouse_delta = get_global_mouse_position() - _click_position
	
	# Transforms all the sprite textures to local textures
	var clock := Clock.new()
	
	local_renderer.begin_frame(output_texture_rect.size, _zoom, _offset - mouse_delta / _zoom)
	local_renderer.render_clear(Color.BLUE)
	
	for sprite in sprites_container.get_children():
		
		for i in range(1000):
			var sprite_size = sprite.texture.get_size() * sprite.scale
			local_renderer.render_sprite(
				sprite.position,
				sprite_size,
				sprite.rotation,
				sprite.modulate,
				sprite.texture,
				0
			)
		
	local_renderer.end_frame()
	clock.print_elapsed("Rendered")
	
	clock.restart()
	var color_attachment = local_renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.COLOR)
	output_texture_rect.texture = color_attachment.create_texture_2d_rd()
	clock.print_elapsed("Texture copied")
	
