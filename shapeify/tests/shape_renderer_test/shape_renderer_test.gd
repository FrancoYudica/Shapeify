extends Node

@export var source_texture: RendererTextureLoad
@export var shape_texture: RendererTextureLoad


@onready var _shape_renderer := ShapeRenderer.new()

func _ready() -> void:
	_shape_renderer.source_texture = source_texture
	
func _process(delta: float) -> void:
	var shape = Shape.new()
	shape.texture = shape_texture
	shape.position = Vector2(0.5, 0.5)
	shape.size.x = 0.1
	shape.size.y = shape.size.x * float(source_texture.get_width()) / source_texture.get_height()
	
	shape.rotation = Time.get_ticks_msec() * 0.001
	shape.tint = Color.WHITE
	_shape_renderer.render_shape(shape)
