extends ShapeTextureInitializer

var _available_textures: Array[LocalTexture]

func initialize_attribute(shape: Shape) -> void:
	shape.texture = _available_textures.pick_random()

func set_params(params: ShapeSpawnerParams):
	
	_available_textures.clear()
	
	for texture in params.textures:
		var local_texture = LocalTexture.load_from_texture(texture, GenerationGlobals.algorithm_rd)
		_available_textures.append(local_texture)
