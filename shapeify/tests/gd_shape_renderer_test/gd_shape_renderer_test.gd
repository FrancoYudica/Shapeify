extends Control

@export var shapes: Array[Shape]
@export var gd_shape_renderer: SubViewport

func _ready() -> void:

	gd_shape_renderer.size = Vector2(640, 960)

	for shape in shapes:
		gd_shape_renderer.add_shape(shape)
	
