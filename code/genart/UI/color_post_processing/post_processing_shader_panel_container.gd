extends PanelContainer

@export var remove_button: Button
@export var enabled_check_button: CheckBox

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
	
	enabled_check_button.toggled.connect(
		func(toggled_on):
			params.enabled = toggled_on
	)
	
	enabled_check_button.button_pressed = params.enabled
