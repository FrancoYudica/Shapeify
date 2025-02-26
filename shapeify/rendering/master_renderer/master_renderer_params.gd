## The params include all the necessary information to archive the final image rendering
class_name MasterRendererParams extends Resource

@export var shapes: Array[Shape]:
	set(value):
		if shapes != value:
			shapes = value
			emit_changed()
			
@export var clear_color: Color:
	set(value):
		if clear_color != value:
			clear_color = value
			emit_changed()

@export var post_processing_pipeline_params: ShapeColorPostProcessingPipelineParams

func setup_signals():
	post_processing_pipeline_params.changed.connect(emit_changed)
