## Holds a set of genetic attributes
class_name Individual extends Resource

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
	
	var rotation_matrix = Transform2D(rotation, Vector2.ZERO)

	var local_positions = [
		0.5 * Vector2(-size.x, -size.y),
 		0.5 * Vector2(-size.x, size.y),
 		0.5 * Vector2(size.x, size.y),
 		0.5 * Vector2(size.x, -size.y)
	]
	
	# Finds top, bottom, left and right after rotating the local positions 
	# around individual's center
	var top: float = INF
	var bottom: float = -INF
	var left: float = INF
	var right: float = -INF
	
	for local_position in local_positions:
		
		# Rotates around the center and translates
		var pos = Vector2(position.x, position.y) + rotation_matrix * local_position
		top = min(pos.y, top)
		bottom = max(pos.y, bottom)
		left = min(pos.x, left)
		right = max(pos.x, right)
	
	# Builds Axis aligned bounding box
	var top_left = Vector2i(int(left), int(top))
	var size = Vector2i(
		int(right - left),
		int(bottom - top)
	)
	
	var rect = Rect2i(top_left, size)
	
	return rect

func copy() -> Individual:
	var ind = Individual.new()
	ind.position = position
	ind.size = size
	ind.rotation = rotation
	ind.texture = texture
	ind.tint = tint
	ind.fitness = fitness
	return ind


func to_dict() -> Dictionary:
	return {
		"position_x": position.x,
		"position_y": position.y,
		"size_x": size.x,
		"size_y": size.y,
		"rotation": rotation,
		"fitness": fitness
	}
