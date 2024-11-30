class_name ImageGeneratorParams extends Resource

enum IndividualGeneratorType{
	Random,
	Genetic
}

@export var individual_generator_params: IndividualGeneratorParams
@export var individual_generator_type: IndividualGeneratorType
@export var individual_count: int = 10
