extends MutationStrategy


func mutate(individual: Individual) -> void:
	
	# Individual size is scaled by [-50%, 50%]
	individual.size.x *= randf_range(0.75, 1.5)
	individual.size.y *= randf_range(0.75, 1.5)
	
	# Position mutation is proportional to it's size
	individual.position.x += randf_range(
		-individual.size.x * 0.5,
		individual.size.x * 0.5
	)
	individual.position.y += randf_range(
		-individual.size.y * 0.5,
		individual.size.x * 0.5
	)

	individual.rotation += randf_range(-PI * 0.5, PI * 0.5)
