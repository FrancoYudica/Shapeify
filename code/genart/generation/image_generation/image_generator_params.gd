class_name ImageGeneratorParams extends Resource

enum Type
{
	CUSTOM,
	FAST,
	PERFORMANCE,
	QUALITY
}

@export var type: Type = Type.CUSTOM

@export var weight_texture_generator_type := WeightTextureGenerator.Type.WHITE:
	set(value):
		weight_texture_generator_type = value
		emit_changed()

@export var individual_generator_params := IndividualGeneratorParams.new():
	set(value):
		individual_generator_params = value
		emit_changed()

@export var individual_generator_type := IndividualGenerator.Type.Genetic:
	set(value):
		individual_generator_type = value
		emit_changed()

@export var stop_condition := StopCondition.Type.INDIVIDUAL_COUNT:
	set(value):
		stop_condition = value
		emit_changed()

@export var stop_condition_params := StopConditionParams.new():
	set(value):
		stop_condition_params = value
		emit_changed()

@export var clear_color_type := ClearColorStrategy.Type.AVERAGE:
	set(value):
		clear_color_type = value
		emit_changed()

@export var clear_color_params := ClearColorParams.new():
	set(value):
		clear_color_params = value
		emit_changed()

@export var weight_texture_generator_params := WeightTextureGeneratorParams.new():
	set(value):
		weight_texture_generator_params = value
		emit_changed()

func to_dict():
	return {
		"stop_condition": StopCondition.Type.keys()[stop_condition],
		"stop_condition_params" : stop_condition_params.to_dict(),
		"individual_generator": IndividualGenerator.Type.keys()[individual_generator_type],
		"individual_generator_params" : individual_generator_params.to_dict()
	}
	
func setup_changed_signals() -> void:
	individual_generator_params.setup_changed_signals()
	individual_generator_params.changed.connect(emit_changed)
	stop_condition_params.changed.connect(emit_changed)
	clear_color_params.changed.connect(emit_changed)
	weight_texture_generator_params.changed.connect(emit_changed)
