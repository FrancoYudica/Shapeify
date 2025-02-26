class_name ShapeAttributeInitializer extends RefCounted

## Progress in the image generation process
var similarity: float = 0.0

func initialize_attribute(shape: Shape) -> void:
	pass

## Called when the spawner has to update it's properties
func update(
	target_texture: LocalTexture,
	source_texture: LocalTexture,
	weight_texture: LocalTexture) -> void:
	pass

func set_params(params: ShapeSpawnerParams):
	pass
