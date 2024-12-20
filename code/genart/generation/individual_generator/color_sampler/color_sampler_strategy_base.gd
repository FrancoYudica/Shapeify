class_name ColorSamplerStrategy extends RefCounted


enum Type
{
	SUB_RECT,
	MASKED
}

@export var sample_texture: RendererTexture:
	set(texture):
		sample_texture = texture
		_sample_texture_set()

func set_sample_color(individual: Individual) -> void:
	individual.tint = Color.WHITE

func _sample_texture_set():
	pass

static func factory_create(type: Type) -> ColorSamplerStrategy:
	match type:
		Type.SUB_RECT:
			return load("res://generation/individual_generator/color_sampler/subrect_color_sampler_strategy.gd").new()
		Type.MASKED:
			return load("res://generation/individual_generator/color_sampler/masked_color_sampler_strategy.gd").new()
		_:
			push_error("Unimplemented color sampler of type: %s" % Type.keys()[type])
			return null
