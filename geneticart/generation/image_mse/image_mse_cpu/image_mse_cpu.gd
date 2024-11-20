@tool
extends Node

signal texture_rendered(texture: ViewportTexture)

@export var _target_texture: Texture2D
@export var _current_texture: Texture2D
@export var individual: Node

@onready var _result_sub_viewport := $CanvasLayer/ResultSubViewportContainer/ResultSubViewport

@onready var _result_texture_rect := $CanvasLayer/ResultSubViewportContainer/ResultSubViewport/ResultTextureRect

class _RenderCommand:
	var id = 0
	var target_texture: Texture2D
	var current_texture: Texture2D
	var individual

var _render_queue: Array[_RenderCommand] = []


func push_render(
	id, 
	target_texture,
	current_texture,
	individual):
		
		# Creates the render command and queues
		var command = _RenderCommand.new()
		command.id = id
		command.target_texture = target_texture
		command.current_texture = current_texture
		command.individual = individual
		_render_queue.append(command)

func _ready() -> void:
	RenderingServer.frame_post_draw.connect(_frame_post_draw)
	RenderingServer.frame_pre_draw.connect(_frame_pre_draw)
	push_render(0, _target_texture, _current_texture, null)

func _process(delta: float) -> void:
	
	if _target_texture != null:
		var texture_size = _target_texture.get_size()
		_result_sub_viewport.size = texture_size
		
	_result_texture_rect.material.set_shader_parameter("target_texture", _target_texture)
	_result_texture_rect.material.set_shader_parameter("current_texture", _current_texture)

## Changes rendering states to render the command
func _setup_render_command(command: _RenderCommand):
	var texture_size = command.target_texture.get_size()
	_result_sub_viewport.size = texture_size
	_result_texture_rect.material.set_shader_parameter("target_texture", command.target_texture)
	_result_texture_rect.material.set_shader_parameter("current_texture", command.current_texture)
	
	
func _frame_pre_draw():
	
	if Engine.is_editor_hint() or _render_queue.size() == 0:
		return
	
	# Pops the command and sets up
	var command: _RenderCommand = _render_queue[0]
	_setup_render_command(command)

## If there is any command rendering, removes from list and emits resulting texture
func _frame_post_draw():
	
	if Engine.is_editor_hint() or _render_queue.size() == 0:
		return
	
	_render_queue.pop_front()
	texture_rendered.emit(_result_sub_viewport.get_texture())
	_calculate_mse(_result_sub_viewport.get_texture())
	
## CPU calculation of Median Squared Error. 
func _calculate_mse(texture: ViewportTexture) -> void:
	
	var t = Time.get_ticks_msec()

	var image: Image = texture.get_image()
	var num_channels = 3.0
	
	# Term used to normalize the MSE
	var f = 1.0 / (image.get_width() * image.get_height() * num_channels)
	
	var mse = 0.0
	
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var color = image.get_pixel(x, y)
			var term = color.r * color.r + color.g * color.g + color.b * color.b
			mse += f * term
	
	print("MSE: %s" % mse)
	print("Compute time taken: %sms " % (Time.get_ticks_msec() - t))

	
