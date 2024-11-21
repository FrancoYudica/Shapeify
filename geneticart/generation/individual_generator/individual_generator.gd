# An algorithm that, given a set of parameters, a target texture, and a source texture, 
# generates the best possible individual. This individual, when added to the source texture, 
# minimizes the error metric relative to the target texture.
class_name IndividualGenerator extends Node


@export var average_color_sampler: AverageColorSampler
@export var error_metric: ErrorMetric
@export var individual_src_texture_renderer: Node
@export var populator: Populator

func generate_individual(params: IndividualGeneratorParams) -> Individual:
	return
