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
