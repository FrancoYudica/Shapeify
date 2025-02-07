extends PanelContainer

@export var remove_button: TextureButton

var _pipeline_params: ShapeColorPostProcessingPipelineParams:
	get:
		return Globals.settings.color_post_processing_pipeline_params

var params: ShapeColorPostProcessingShaderParams

func _ready() -> void:
	remove_button.pressed.connect(
		func():
			
			# Finds the index of the params and removes
			for i in range(_pipeline_params.shader_params.size()):
				var shader_params = _pipeline_params.shader_params[i]
				if shader_params == params:
					_pipeline_params.shader_params.pop_at(i)
					break
					
			queue_free()
	)
