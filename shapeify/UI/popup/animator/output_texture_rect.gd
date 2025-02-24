extends TextureRect

@export var animator: Node

func _ready() -> void:
	animator.shapes_animated.connect(_animated_shapes)
	
func _animated_shapes(details: ImageGenerationDetails):
	# Renders the image
	ImageGenerationRenderer.render_image_generation(GenerationGlobals.renderer, details)

	# Copies textures contents into TextureRect's texture
	var color_attachment = GenerationGlobals.renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.COLOR)
	texture = color_attachment.create_texture_2d_rd()
