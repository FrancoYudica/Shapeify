class_name SurvivorSelectionParams extends Resource

@export var elitisim_rate: float = 0.1:
	set(value):
		if value != elitisim_rate:
			elitisim_rate = value
			emit_changed()

@export var tournament_size: int = 10:
	set(value):
		if value != tournament_size:
			tournament_size = value
			emit_changed()

func to_dict() -> Dictionary:
	return {
		"elitisim_rate" : elitisim_rate,
		"tournament_size" : tournament_size
	}
