extends TextureRect

@export var output_texture_holder: Node

func _process(delta: float) -> void:
	texture = output_texture_holder.texture
