class_name AnimationRenderer extends RefCounted

var animation_player: IndividualAnimationPlayer
var image_generation_details: ImageGenerationDetails

var _white_texture: RendererTexture = null



func render_frame(t: float) -> Image:
	
	if _white_texture == null:
		_white_texture = RendererTexture.load_from_path("res://art/white_1x1.png")
		
	
	var frame_individuals := animation_player.animate(
		image_generation_details.individuals,
		image_generation_details.viewport_size,
		t
	)
	_render_individuals(frame_individuals)
	
	var color_attachment = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)
	var color_attachment_data = Renderer.rd.texture_get_data(color_attachment.rd_rid, 0)
	var img = ImageUtils.create_image_from_rgbaf_buffer(
		color_attachment.get_width(),
		color_attachment.get_height(),
		color_attachment_data
	)
	return img
	

func _render_individuals(individuals):
	
	var viewport_size = image_generation_details.viewport_size
	Renderer.begin_frame(viewport_size)
	
	# Renders background
	Renderer.render_sprite(
		viewport_size * 0.5,
		viewport_size,
		0.0,
		image_generation_details.clear_color,
		_white_texture,
		0.0)
	
	# Renders individuals
	for individual in individuals:
		Renderer.render_sprite(
			individual.position,
			individual.size,
			individual.rotation,
			individual.tint,
			individual.texture,
			1.0)
	Renderer.end_frame()
