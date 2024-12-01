class_name MatingPoolStrategy extends RefCounted

enum MatingPoolType {
	UNIFORM, # The population is the mating pool
	SELECTION_RANKING
}

func create(population: Array[Individual]) -> Array[Individual]:
	return population
