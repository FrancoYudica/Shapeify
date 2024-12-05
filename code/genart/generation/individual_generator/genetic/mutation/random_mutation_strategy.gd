extends MutationStrategy

var _genetic_params: GeneticIndividualGeneratorParams

func mutate(individual: Individual) -> void:
	
	# Individual size is scaled by [-50%, 50%]
	
	individual.size.x *= randf_range(1.0 - 0.25 * _genetic_params.mutation_factor, 1.0 + 0.5 * _genetic_params.mutation_factor) * _genetic_params.mutation_factor
	individual.size.y *= randf_range(1.0 - 0.25 * _genetic_params.mutation_factor, 1.0 + 0.5 * _genetic_params.mutation_factor) * _genetic_params.mutation_factor
	
	# Position mutation is proportional to it's size
	individual.position.x += randf_range(
		-individual.size.x * 0.5,
		individual.size.x * 0.5
	) * _genetic_params.mutation_factor
	individual.position.y += randf_range(
		-individual.size.y * 0.5,
		individual.size.y * 0.5
	) * _genetic_params.mutation_factor

	individual.rotation = fmod(
		individual.rotation + 
		randf_range(-PI * 0.5, PI * 0.5) * 
		_genetic_params.mutation_factor, 2 * PI)


func set_params(params: GeneticIndividualGeneratorParams) -> void:
	_genetic_params = params
