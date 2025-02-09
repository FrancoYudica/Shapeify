extends TextureRect

@export var gd_shape_renderer: SubViewport

func _ready() -> void:
	Globals.target_texture_updated.connect(_clear_shapes)
	Globals.generation_cleared.connect(_clear_shapes)
	Globals.generation_started.connect(
		func():
			# Connects signal directly to the image generator. This will run in the
			# algorithm thread, slowing it down by the texture copy time. 
			Globals.shape_generated.connect(_shape_generated)
			
	)
	Globals.generation_finished.connect(
		func():
			Globals.shape_generated.disconnect(_shape_generated)
	)
	texture.viewport_path = gd_shape_renderer.get_path()

func _clear_shapes():
	gd_shape_renderer.clear_color = Globals.image_generation_details.clear_color
	gd_shape_renderer.clear()

func _process(delta: float) -> void:
	var parent_size = get_parent().get_global_rect().size
	var target_texture = Globals.settings.image_generator_params.target_texture
	var target_texture_aspect_ratio = float(target_texture.get_width()) / target_texture.get_height()
	gd_shape_renderer.size.y = parent_size.y
	gd_shape_renderer.size.x = parent_size.y * target_texture_aspect_ratio

func _shape_generated(shape):
	gd_shape_renderer.add_shape(shape)
