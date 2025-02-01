class_name ShapePositionInitializerParms extends Resource

@export var weight_texture_generator_params := WeightTextureGeneratorParams.new()

func _init() -> void:
	weight_texture_generator_params.changed.connect(emit_changed)
