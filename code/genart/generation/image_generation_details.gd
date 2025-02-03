## Information used to replicate the generated image.
class_name ImageGenerationDetails extends RefCounted

## Shapes in order of generation
var shapes: Array[Shape] = []

## Initial color of the generated texture
var clear_color := Color.BLACK

## Size of the generated texture
var viewport_size: Vector2i

## Scale factor used to generate the image
var render_scale: float = 1.0

var time_taken_ms: int

var executed_count: int

var generated_texture: RendererTexture
