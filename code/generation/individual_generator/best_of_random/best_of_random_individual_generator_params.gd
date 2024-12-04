class_name BestOfRandomIndividualGeneratorParams extends Resource

@export var individual_count: int = 300

func to_dict() -> Dictionary:
	return {
		"individual_count" : individual_count
	}
