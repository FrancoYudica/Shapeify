class_name IndividualGeneratorParams extends Resource

@export var populator_params := PopulatorParams.new()
@export var target_texture: RendererTexture

@export var color_sampler := ColorSamplerStrategy.Type.MASKED

@export var clear_color_average: bool = true
@export var keep_aspect_ratio: bool = false
@export var clamp_position_in_canvas: bool = true
@export var fixed_rotation: bool = true
@export var fixed_rotation_angle: float = 0.0
@export var fixed_size: bool = false
@export var fixed_size_width_ratio: float = 0.1

@export var best_of_random_params := BestOfRandomIndividualGeneratorParams.new()
@export var genetic_params := GeneticIndividualGeneratorParams.new()


func to_dict() -> Dictionary:
	return {
		"target_texture_width" : target_texture.get_width(),
		"target_texture_height" : target_texture.get_height(),
		"color_sampler": ColorSamplerStrategy.Type.keys()[color_sampler],
		"best_of_random_params" : best_of_random_params.to_dict(),
		"genetic_params" : genetic_params.to_dict()
	}
