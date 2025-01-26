extends ColorSamplerStrategy

var _shape_renderer: ShapeRenderer

var _masked_sampler: AverageColorSampler

func _init() -> void:
	_shape_renderer = ShapeRenderer.new()
	_masked_sampler = preload("res://generation/average_color_sampler/masked/average_masked_color_sampler.gd").new()
	
func set_sample_color(shape: Shape) -> void:

	# Renders to get the ID texture
	_shape_renderer.render_shape(shape)
	
	# Gets masked avg color
	_masked_sampler.id_texture = _shape_renderer.get_id_attachment_texture()
	shape.tint = _masked_sampler.sample_rect(shape.get_bounding_rect())

func _sample_texture_set():
	_shape_renderer.source_texture = sample_texture
	_masked_sampler.sample_texture = sample_texture
