extends ColorSamplerStrategy

var _masked_sampler: AverageColorSampler

func _init() -> void:
	_masked_sampler = preload("res://generation/average_color_sampler/masked/average_masked_color_sampler.gd").new()
	
func set_sample_color(shape: Shape) -> void:

	# Renders to get the ID texture
	var renderer: LocalRenderer = GenerationGlobals.renderer
	ShapeRenderer.render_shape(renderer, sample_texture, shape)
	
	# Gets masked avg color
	_masked_sampler.id_texture = renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.UID)
	
	# Maps normalized bounding rect to canvas bounding rect
	var normalized_bounding_rect = shape.get_bounding_rect()
	var bounding_rect = Rect2i(
		normalized_bounding_rect.position.x * sample_texture.get_width(),
		normalized_bounding_rect.position.y * sample_texture.get_height(),
		max(1.0, normalized_bounding_rect.size.x * sample_texture.get_width()),
		max(1.0, normalized_bounding_rect.size.y * sample_texture.get_height())
	)
	# Samples
	shape.tint = _masked_sampler.sample_rect(bounding_rect)

func _sample_texture_set():
	_masked_sampler.sample_texture = sample_texture
