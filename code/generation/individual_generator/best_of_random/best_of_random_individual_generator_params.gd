class_name BestOfRandomIndividualGeneratorParams extends Resource

@export var individual_count: int = 300
@export var fitness_calculator := FitnessCalculator.Type.MPA_RGB

func to_dict() -> Dictionary:
	return {
		"individual_count" : individual_count,
		"fitness_calculator": FitnessCalculator.Type.keys()[fitness_calculator]
	}
