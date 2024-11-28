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
	individual.position = Vector2(64, 64)
	individual.size = Vector2(128, 128)
	individual.rotation = 0.0
	individual.tint = Color.WHITE
	individual.texture = individual_texture
	_individual_renderer.render_individual(individual)
