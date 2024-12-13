class_name ImageGenerationRenderer extends RefCounted

static var _white_texture_rd: RendererTexture

static func render_image_generation(
	renderer,
	details: ImageGenerationDetails):
	
	if _white_texture_rd == null:
		var tex = load("res://art/white_1x1.png")
		_white_texture_rd = RendererTexture.new()
		_white_texture_rd.rd_rid = RenderingCommon.create_local_rd_texture_copy(tex)
	
	var viewport_size = details.viewport_size
	renderer.begin_frame(viewport_size)
	
	# Renders background
	renderer.render_sprite(
		viewport_size * 0.5,
		viewport_size,
		0.0,
		details.clear_color,
		_white_texture_rd,
		0.0)
	
	# Renders individuals
	for individual in details.individuals:
		renderer.render_sprite(
			individual.position,
			individual.size,
			individual.rotation,
			individual.tint,
			individual.texture,
			1.0)
	renderer.end_frame()
