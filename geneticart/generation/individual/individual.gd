## Holds a set of genetic attributes
class_name Individual extends Resource

@export var id: int = 0

## Central position of the Individual when rendered
@export var position: Vector2i

## Size of the rendered texture
@export var size: Vector2

## Clockwise rotation that starts from +X axis
@export_range(0.0, PI * 2.0) var rotation: float

@export var texture: Texture2D

## Used to modulate the texture color
@export var tint: Color = Color.WHITE

@export_range(0.0, 1.0) var fitness: float
