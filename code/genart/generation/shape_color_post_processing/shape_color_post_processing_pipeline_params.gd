class_name ShapeColorPostProcessingPipelineParams extends Resource

@export var shader_params: Array[ShapeColorPostProcessingShaderParams] = []
@export var enabled: bool = true:
	set(value):
		if value != enabled:
			enabled = value
			emit_changed()

func add_shader_param(param: ShapeColorPostProcessingShaderParams):
	shader_params.append(param)
	param.setup_signals()
	param.changed.connect(emit_changed)
	emit_changed()

func remove(params: ShapeColorPostProcessingShaderParams):
	# Finds the index of the params and removes
	for i in range(shader_params.size()):
		var local_params = shader_params[i]
		if local_params == params:
			shader_params.pop_at(i)
			break
			
	emit_changed()

func setup_signals():
	for param in shader_params:
		param.setup_signals()
		param.changed.connect(emit_changed)
