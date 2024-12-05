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
