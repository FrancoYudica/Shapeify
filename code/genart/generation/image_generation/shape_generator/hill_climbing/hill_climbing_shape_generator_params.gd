class_name HillClimbingShapeGeneratorParams extends Resource

@export var max_age: int = 100:
	set(value):
		if value != max_age:
			max_age = value
			emit_changed()

@export var random_restart_count: int = 1

@export var initial_random_samples: int = 5

@export var fitness_calculator := FitnessCalculator.Type.MPA_RGB:
	set(value):
		if value != fitness_calculator:
			fitness_calculator = value
			emit_changed()

@export var position_mutation_weight: int = 1:
	set(value):
		if value != position_mutation_weight:
			position_mutation_weight = value
			emit_changed()
			
@export var size_mutation_weight: int = 2:
	set(value):
		if value != size_mutation_weight:
			size_mutation_weight = value
			emit_changed()

@export var rotation_mutation_weight: int = 2:
	set(value):
		if value != rotation_mutation_weight:
			rotation_mutation_weight = value
			emit_changed()

func to_dict() -> Dictionary:
	return {
		"max_age" : max_age,
		"ranndom_restart_count" : random_restart_count,
		"fitness_calculator": FitnessCalculator.Type.keys()[fitness_calculator]
	}

func setup_changed_signals() -> void:
	pass
