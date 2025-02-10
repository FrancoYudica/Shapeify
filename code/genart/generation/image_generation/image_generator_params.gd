class_name ImageGeneratorParams extends Resource

enum Type
{
	CUSTOM,
	SUPER_FAST,
	FAST,
	PERFORMANCE,
	QUALITY
}

@export var type: Type = Type.CUSTOM

@export var shape_generator_params := ShapeGeneratorParams.new():
	set(value):
		shape_generator_params = value
		emit_changed()

@export var shape_generator_type := ShapeGenerator.Type.Genetic:
	set(value):
		shape_generator_type = value
		emit_changed()

@export var stop_condition := StopCondition.Type.SHAPE_COUNT:
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

@export var render_scale := 1.0:
	set(value):
		if value != render_scale:
			render_scale = value
			emit_changed()
	
## Holds the target texture without any transformation
@export var target_texture: RendererTexture:
	set(value):
		if value != target_texture:
			target_texture = value
			emit_changed()

func to_dict():
	return {
		"stop_condition": StopCondition.Type.keys()[stop_condition],
		"stop_condition_params" : stop_condition_params.to_dict(),
		"shape_generator": ShapeGenerator.Type.keys()[shape_generator_type],
		"shape_generator_params" : shape_generator_params.to_dict()
	}
	
func setup_changed_signals() -> void:
	shape_generator_params.setup_changed_signals()
	shape_generator_params.changed.connect(emit_changed)
	stop_condition_params.changed.connect(emit_changed)
	clear_color_params.changed.connect(emit_changed)
	weight_texture_generator_params.changed.connect(emit_changed)
