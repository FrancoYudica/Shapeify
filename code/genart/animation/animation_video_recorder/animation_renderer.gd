class_name AnimationRenderer extends RefCounted

var animation_player: IndividualAnimationPlayer
var image_generation_details: ImageGenerationDetails

func render_frame(t: float) -> Image:
	
	var frame_individuals := animation_player.animate(
		image_generation_details.individuals,
		image_generation_details.viewport_size,
		t
	)
	var details := ImageGenerationDetails.new()
	details.individuals = frame_individuals
	details.viewport_size = image_generation_details.viewport_size
	details.clear_color = image_generation_details.clear_color
	
	ImageGenerationRenderer.render_image_generation(Renderer, details)
	
	var color_attachment = Renderer.get_attachment_texture(Renderer.FramebufferAttachment.COLOR)
	var color_attachment_data = Renderer.rd.texture_get_data(color_attachment.rd_rid, 0)
	var img = ImageUtils.create_image_from_rgbaf_buffer(
		color_attachment.get_width(),
		color_attachment.get_height(),
		color_attachment_data
	)
	return img
