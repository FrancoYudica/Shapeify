extends ShapeTextureInitializer

var _available_textures: Array[RendererTexture]

func initialize_attribute(shape: Shape) -> void:
	shape.texture = _available_textures.pick_random()

func set_params(params: ShapeSpawnerParams):
	_available_textures = params.textures
