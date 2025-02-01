class_name ShaderDrivenShapeGeneratorParams extends Resource

@export var max_age: int = 20:
	set(value):
		if value != max_age:
			max_age = value
			emit_changed()

@export var fitness_calculator := FitnessCalculator.Type.MPA_RGB:
	set(value):
		if value != fitness_calculator:
			fitness_calculator = value
			emit_changed()

func to_dict() -> Dictionary:
	return {
		"max_age" : max_age,
		"fitness_calculator": FitnessCalculator.Type.keys()[fitness_calculator]
	}

func setup_changed_signals() -> void:
	pass
