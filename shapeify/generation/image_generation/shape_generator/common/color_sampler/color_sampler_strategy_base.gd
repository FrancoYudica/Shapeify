## Given the sample texture and other parameters the 
## ColorSamplerStrategy sets the Shape's tint color
class_name ColorSamplerStrategy extends RefCounted

enum Type
{
	SUB_RECT,
	MASKED,
	WHITE
}

@export var sample_texture: LocalTexture:
	set(texture):
		sample_texture = texture
		_sample_texture_set()

var type: Type

func set_sample_color(shape: Shape) -> void:
	shape.tint = Color.WHITE

func _sample_texture_set():
	pass

static func factory_create(type: Type) -> ColorSamplerStrategy:
	match type:
		Type.SUB_RECT:
			var strategy = load("res://generation/image_generation/shape_generator/common/color_sampler/subrect_color_sampler_strategy.gd").new()
			strategy.type = type
			return strategy
		Type.MASKED:
			var strategy = load("res://generation/image_generation/shape_generator/common/color_sampler/masked_color_sampler_strategy.gd").new()
			strategy.type = type
			return strategy
		Type.WHITE:
			var strategy = load("res://generation/image_generation/shape_generator/common/color_sampler/white_color_sampler_strategy.gd").new()
			strategy.type = type
			return strategy
		_:
			push_error("Unimplemented color sampler of type: %s" % Type.keys()[type])
			return null
