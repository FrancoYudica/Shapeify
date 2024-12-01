extends Node

@export var source_texture: RendererTextureLoad
@export var individual_texture: RendererTextureLoad

@export var individual_renderer_script: GDScript

var _individual_renderer: IndividualRenderer

func _ready() -> void:
	_individual_renderer = individual_renderer_script.new()
	_individual_renderer.source_texture = source_texture
	
func _process(delta: float) -> void:
	var individual = Individual.new()
	individual.texture = individual_texture
	individual.position = Vector2(512, 512)
	individual.size.x = 256
	individual.size.y = individual.size.x * float(individual.texture.get_height()) / individual.texture.get_width()
	
	individual.rotation = Time.get_ticks_msec() * 0.001
	individual.tint = Color.WHITE
	_individual_renderer.render_individual(individual)
