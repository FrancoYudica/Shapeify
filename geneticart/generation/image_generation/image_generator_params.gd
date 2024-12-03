class_name ImageGeneratorParams extends Resource

enum IndividualGeneratorType{
	Random,
	Genetic
}

@export var individual_generator_params: IndividualGeneratorParams
@export var individual_generator_type: IndividualGeneratorType
@export var stop_condition: StopCondition.Type = StopCondition.Type.INDIVIDUAL_COUNT
@export var stop_condition_params := StopConditionParams.new()
