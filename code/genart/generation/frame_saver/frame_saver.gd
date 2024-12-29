class_name FrameSaver extends RefCounted

enum Type
{
	PNG,
	JPG,
	WEBP,
	JSON_FORMAT
}

func save(
	filepath: String,
	individuals: Array[Individual],
	clear_color: Color,
	viewport_size: Vector2i,
	viewport_scale: float) -> bool:
	return false

func get_extension() -> String:
	return ""

static func factory_create(type: Type) -> FrameSaver:
	match type:
		Type.PNG:
			return load("res://generation/frame_saver/strategies/png_frame_save_strategy.gd").new()
		Type.JPG:
			return load("res://generation/frame_saver/strategies/jpg_frame_save_strategy.gd").new()
		Type.WEBP:
			return load("res://generation/frame_saver/strategies/webp_frame_save_strategy.gd").new()
		_:
			return null
