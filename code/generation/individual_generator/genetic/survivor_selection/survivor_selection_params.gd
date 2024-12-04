class_name SurvivorSelectionParams extends Resource

@export var elitisim_rate: float = 0.1
@export var tournament_size: int = 10

func to_dict() -> Dictionary:
	return {
		"elitisim_rate" : elitisim_rate,
		"tournament_size" : tournament_size
	}
