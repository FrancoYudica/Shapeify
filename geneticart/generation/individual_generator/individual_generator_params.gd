class_name IndividualGeneratorParams extends Resource

@export var populator_params: PopulatorParams
@export var target_texture: RendererTexture
@export var clear_color_average: bool = true

@export var genetic_params := GeneticIndividualGeneratorParams.new()
