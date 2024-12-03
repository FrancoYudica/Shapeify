class_name IndividualGeneratorParams extends Resource

@export var populator_params: PopulatorParams
@export var target_texture: RendererTexture
@export var clear_color_average: bool = true

@export var keep_aspect_ratio: bool = false
@export var clamp_position_in_canvas: bool = true
@export var fixed_rotation: bool = true
@export var fixed_rotation_angle: float = 0.0

@export var random_params := RandomIndividualGeneratorParams.new()
@export var genetic_params := GeneticIndividualGeneratorParams.new()
