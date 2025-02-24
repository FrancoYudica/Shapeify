## The master renderer receives a set of data and renders the final image that the program
## outputs. This takes the shapes, post processing effects and more
class_name MasterRenderer extends RefCounted

static func render(
	renderer: LocalRenderer,
	viewport_size: Vector2i,
	params: MasterRendererParams) -> void:
	
	# Applies post processing to shapes
	var processed_shapes = ShapeColorPostProcessingPipeline.execute_pipeline(
		params.shapes, 0, params.post_processing_pipeline_params)
	
	var processed_clear_color = ShapeColorPostProcessingPipeline.compute_clear_color(
		params.clear_color, 0, params.post_processing_pipeline_params)
	
	_render_shapes(
		renderer,
		processed_shapes,
		processed_clear_color,
		viewport_size.max(Vector2i.ONE)
	)

static func _render_shapes(
	renderer: LocalRenderer,
	shapes: Array[Shape],
	clear_color: Color,
	viewport_size: Vector2i):
	
	renderer.begin_frame(viewport_size)
	
	# Renders background
	renderer.render_clear(clear_color)
	
	var viewport_size_f = Vector2(viewport_size.x, viewport_size.y)
	
	# Renders shapes
	for shape in shapes:
		renderer.render_sprite(
			shape.position * viewport_size_f,
			shape.size * viewport_size_f,
			shape.rotation,
			shape.tint,
			shape.texture,
			1.0)
	renderer.end_frame()
