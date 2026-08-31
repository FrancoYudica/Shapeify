class_name ShapeAspectRatioFixParams extends Resource

@export var type := ShapeAspectRatioFixer.Type.KeepTextureRatio:
	set(value):
		if value != type:
			type = value
			emit_changed()

@export var random_range_aspect_ratio_min: float = 0.5:
	set(value):
		if value != random_range_aspect_ratio_min:
			random_range_aspect_ratio_min = value
			emit_changed()
			
@export var random_range_aspect_ratio_max: float = 1.5:
	set(value):
		if value != random_range_aspect_ratio_max:
			random_range_aspect_ratio_max = value
			emit_changed()
