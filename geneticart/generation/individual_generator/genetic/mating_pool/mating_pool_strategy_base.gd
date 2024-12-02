class_name MatingPoolStrategy extends RefCounted

enum MatingPoolType {
	UNIFORM, # The population is the mating pool
	SELECTION_RANKING
}

func create(sorted_population: Array[Individual]) -> Array[Individual]:
	return sorted_population
