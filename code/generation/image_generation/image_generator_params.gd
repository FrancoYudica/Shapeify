class_name ImageGeneratorParams extends Resource

enum IndividualGeneratorType{
	Random,
	BestOfRandom,
	Genetic
}

@export var individual_generator_params := IndividualGeneratorParams.new()
@export var individual_generator_type := IndividualGeneratorType.Genetic
@export var stop_condition := StopCondition.Type.INDIVIDUAL_COUNT
@export var stop_condition_params := StopConditionParams.new()

func to_dict():
	return {
		"stop_condition": StopCondition.Type.keys()[stop_condition],
		"stop_condition_params" : stop_condition_params.to_dict(),
		"individual_generator": IndividualGeneratorType.keys()[individual_generator_type],
		"individual_generator_params" : individual_generator_params.to_dict()
	}
