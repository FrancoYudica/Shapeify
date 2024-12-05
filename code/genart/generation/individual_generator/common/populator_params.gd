## Set of parameters used by Populator
class_name PopulatorParams extends Resource

@export var textures: Array[RendererTexture] = []

@export var position_bound_min: Vector2i = Vector2i.ZERO
@export var position_bound_max: Vector2i = Vector2i.ZERO

@export var size_bound_min: Vector2i = Vector2i(8, 8)
@export var size_bound_max: Vector2i = Vector2i(512, 512)
