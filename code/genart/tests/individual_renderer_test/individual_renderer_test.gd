extends Node

@export var source_texture: RendererTextureLoad
@export var individual_texture: RendererTextureLoad

@export var individual_renderer_script: GDScript

var _shape_renderer: ShapeRenderer

func _ready() -> void:
	_shape_renderer = individual_renderer_script.new()
	_shape_renderer.source_texture = source_texture
	
func _process(delta: float) -> void:
	var individual = Individual.new()
	individual.texture = individual_texture
	individual.position = Vector2(512, 512)
	individual.size.x = 256
	individual.size.y = individual.size.x * float(individual.texture.get_height()) / individual.texture.get_width()
	
	individual.rotation = Time.get_ticks_msec() * 0.001
	individual.tint = Color.WHITE
	_shape_renderer.render_shape(individual)
