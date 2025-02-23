## Information used to replicate the generated image.
class_name ImageGenerationDetails extends RefCounted

## Shapes in order of generation
var shapes: Array[Shape] = []

## Initial color of the generated texture
var clear_color := Color.BLACK

## Size of the generated texture
var viewport_size: Vector2i

var time_taken_ms: int

var executed_count: int


func copy() -> ImageGenerationDetails:
	var clone := ImageGenerationDetails.new()
	clone.shapes = shapes
	clone.clear_color = clear_color
	clone.viewport_size = viewport_size
	clone.time_taken_ms = time_taken_ms
	clone.executed_count = executed_count
	return clone
