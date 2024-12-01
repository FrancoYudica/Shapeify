class_name IndividualGeneratorParams extends Resource

@export var populator_params: PopulatorParams
@export var target_texture: RendererTexture
@export var clear_color_average: bool = true

@export var keep_aspect_ratio: bool = false
@export var random_rotation: bool = true
@export var clamp_position_in_canvas: bool = true

@export var random_params := RandomIndividualGeneratorParams.new()
@export var genetic_params := GeneticIndividualGeneratorParams.new()
