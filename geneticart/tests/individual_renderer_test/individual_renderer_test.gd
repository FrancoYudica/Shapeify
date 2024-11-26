extends Node

@export var source_texture: Texture

@export var individual_renderer: IndividualRenderer
@export var individual_texture: Texture
var _individual_texture_rd_rid: RID

func _ready() -> void:
	individual_renderer.source_texture_rd_rid = RenderingCommon.create_local_rd_texture_copy(source_texture)
	_individual_texture_rd_rid = RenderingCommon.create_local_rd_texture_copy(individual_texture)
	
func _process(delta: float) -> void:
	var individual = Individual.new()
	individual.position = Vector2(64, 64)
	individual.size = Vector2(128, 128)
	individual.rotation = 0.0
	individual.tint = Color.WHITE
	individual.texture_rd_rid = _individual_texture_rd_rid
	individual_renderer.render_individual(individual)
