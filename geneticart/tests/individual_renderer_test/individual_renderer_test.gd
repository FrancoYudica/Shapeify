extends Node

@export var source_texture: Texture

@export var individual_renderer: IndividualRenderer
@export var individual: Individual


func _ready() -> void:
	individual_renderer.source_texture_rd_rid = RenderingCommon.create_local_rd_texture_copy(source_texture)
	
func _process(delta: float) -> void:
	individual_renderer.render_individual(individual)
