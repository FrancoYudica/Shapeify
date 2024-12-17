class_name ClearColorStrategy extends RefCounted

enum Type {
	AVERAGE,
	ANY,
	BLACK
}

var sample_texture: RendererTexture:
	set(texture):
		sample_texture = texture
		_sample_texture_set()

func get_clear_color() -> Color:
	return Color.BLACK

func set_params(params: ClearColorParams):
	pass

func _sample_texture_set():
	pass
