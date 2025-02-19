class_name BestOfRandomShapeGeneratorParams extends Resource

@export var shape_count: int = 300:
	set(value):
		if value != shape_count:
			shape_count = value
			emit_changed()

@export var fitness_calculator := FitnessCalculator.Type.MPA_RGB:
	set(value):
		if value != fitness_calculator:
			fitness_calculator = value
			emit_changed()

func to_dict() -> Dictionary:
	return {
		"shape_count" : shape_count,
		"fitness_calculator": FitnessCalculator.Type.keys()[fitness_calculator]
	}

func setup_changed_signals() -> void:
	pass
