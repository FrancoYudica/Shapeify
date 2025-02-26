extends PanelContainer

@export var animator: Node
@export var output_texture_rect: MasterRendererOutputTextureRect

var _master_renderer_params: MasterRendererParams

func _ready() -> void:
	animator.shapes_animated.connect(_animated_shapes)
	
	
func _animated_shapes(shapes: Array[Shape]):
	# Sets up master renderer params
	_master_renderer_params = ImageGeneration.master_renderer_params.duplicate()
	_master_renderer_params.shapes = shapes
	_master_renderer_params.clear_color = ShapeColorPostProcessingPipeline.compute_clear_color(
		_master_renderer_params.clear_color,
		0,
		_master_renderer_params.post_processing_pipeline_params)
	# Disables post processing. It's already applied by the animator, before the shapes are animated
	_master_renderer_params.post_processing_pipeline_params = null
	output_texture_rect.master_renderer_params = _master_renderer_params
