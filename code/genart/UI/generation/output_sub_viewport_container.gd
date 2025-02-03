extends SubViewportContainer

@export var image_generation: Node
@export var gd_shape_renderer: SubViewport

func _ready() -> void:
	image_generation.target_texture_updated.connect(_clear_shapes)
	image_generation.generation_cleared.connect(_clear_shapes)
	image_generation.generation_started.connect(
		func():
			# Connects signal directly to the image generator. This will run in the
			# algorithm thread, slowing it down by the texture copy time. 
			image_generation.image_generator.shape_generated.connect(_shape_generated)
			
	)
	image_generation.generation_finished.connect(
		func():
			image_generation.image_generator.shape_generated.disconnect(_shape_generated)
	)

func _clear_shapes():
	gd_shape_renderer.clear()
	gd_shape_renderer.size = Globals.settings.image_generator_params.target_texture.get_size()
	gd_shape_renderer.clear_color = image_generation.image_generation_details.clear_color

func _shape_generated(shape):
	gd_shape_renderer.add_shape(shape, image_generation.image_generation_details.render_scale)
