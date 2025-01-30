extends Populator

var _texture_position_sampler: TexturePositionSampler
var _texture_position_sampler_type: TexturePositionSampler.Type

func _init() -> void:
	_texture_position_sampler_type = -1

func generate_one(params: PopulatorParams) -> Shape:
	
	var weighted_params := params.weighted_populator_params
	
	if weighted_params.texture_position_sampler_type != _texture_position_sampler_type:
		_update_texture_position_sampler_type(weighted_params.texture_position_sampler_type)
	
	var shape = Shape.new()
	
	# Random position
	shape.position = _texture_position_sampler.sample()

	# Random texture
	shape.texture = params.textures.pick_random()
	
	# Random size
	shape.size.x = randf_range(
		params.size_bound_min.x,
		params.size_bound_max.x)
	shape.size.y = randf_range(
		params.size_bound_min.y,
		params.size_bound_max.y)
	# Random rotation
	shape.rotation = randf_range(0.0, 2.0 * PI)
	return shape
	

func _update_texture_position_sampler_type(type: TexturePositionSampler.Type):
	_texture_position_sampler_type = type
	_texture_position_sampler = TexturePositionSampler.factory_create(type)
	_texture_position_sampler.weight_texture = weight_texture

func _weight_texture_set():
	if _texture_position_sampler != null:
		_texture_position_sampler.weight_texture = weight_texture
