extends PanelContainer

@export var remove_button: Button

var _pipeline_params: ShapeColorPostProcessingPipelineParams:
	get:
		return Globals.settings.color_post_processing_pipeline_params

var params: ShapeColorPostProcessingShaderParams

func _ready() -> void:
	remove_button.pressed.connect(
		func():
			_pipeline_params.remove(params)
			queue_free()
	)
