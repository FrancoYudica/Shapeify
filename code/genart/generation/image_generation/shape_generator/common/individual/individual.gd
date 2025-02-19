## Same as Shape, but it adds the fitness attribute. Individual is used in 
## shape generators that measure each Shape
class_name Individual extends Shape

@export_range(0.0, 1.0) var fitness: float = 0.0

func copy() -> Shape:
	var copied = from_shape(self)
	copied.fitness = fitness
	return copied


func to_dict() -> Dictionary:
	var dict = super.to_dict()
	dict["fitness"] = fitness
	return dict

static func from_shape(shape: Shape) -> Individual:
	var ind = Individual.new()
	ind.position = shape.position
	ind.size = shape.size
	ind.rotation = shape.rotation
	ind.texture = shape.texture
	ind.tint = shape.tint
	ind.fitness = -1.0
	return ind
