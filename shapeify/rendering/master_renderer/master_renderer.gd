## The master renderer receives a set of data and renders the final image that the program
## outputs. This takes the shapes, post processing effects and more
class_name MasterRenderer extends RefCounted

## Applies post processing and renders
static func render(
	renderer: LocalRenderer,
	viewport_size: Vector2i,
	params: MasterRendererParams) -> void:
	
	# Applies post processing to shapes
	var post_processed_params := apply_post_processing(params)
	
	render_shapes(
		renderer,
		post_processed_params.shapes,
		post_processed_params.clear_color,
		viewport_size.max(Vector2i.ONE)
	)

static func apply_post_processing(params: MasterRendererParams) -> MasterRendererParams:
	var new_params = params.duplicate()
	# Applies post processing to shapes
	new_params.shapes = ShapeColorPostProcessingPipeline.execute_pipeline(
		params.shapes, 0, params.post_processing_pipeline_params)
	
	new_params.clear_color = ShapeColorPostProcessingPipeline.compute_clear_color(
		params.clear_color, 0, params.post_processing_pipeline_params)

	return new_params

## Just renders the shapes, without any post processign involved
static func render_shapes(
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
