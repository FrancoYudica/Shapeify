## Holds a set of genetic attributes
class_name Individual extends Resource

@export var id: int = -1

## Central position of the Individual when rendered
@export var position: Vector2i = Vector2.ZERO

## Size of the rendered texture
@export var size: Vector2 = Vector2(128, 128)

## Clockwise rotation that starts from +X axis
@export_range(0.0, PI * 2.0) var rotation: float = 0.0

var texture: RendererTexture

## Used to modulate the texture color
@export var tint: Color = Color.WHITE

@export_range(0.0, 1.0) var fitness: float = 0.0


func get_bounding_rect() -> Rect2i:
	## TODO Change this to calculate with rotation
	var rect = Rect2i(
		int(position.x - size.x * 0.5),
		int(position.y - size.y * 0.5),
		int(size.x),
		int(size.y))
		
	return rect
