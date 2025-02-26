## Executes a sequence of color post processing shaders
class_name ShapeColorPostProcessingPipeline extends RefCounted


static func execute_pipeline(
	shapes: Array[Shape],
	t: float,
	params: ShapeColorPostProcessingPipelineParams
) -> Array[Shape]:
	
	# Duplicates shapes to avoild accumulating the post processing effect over
	# multiple executions of `execute_pipeline()`
	var duplicated_shapes: Array[Shape] = []
	for shape in shapes:
		duplicated_shapes.append(shape.copy())
	
	if params == null or not params.enabled:
		return duplicated_shapes
	
	for param in params.shader_params:
		
		if not param.enabled:
			continue

		# Creates the shader
		var shader := ShapeColorPostProcessingShader.factory_create(param.type)
		
		# Sets parameters and executes
		shader.set_params(param)
		_execute_shader(duplicated_shapes, shader, t)
		
	return duplicated_shapes

static func compute_clear_color(
	src_clear_color: Color,
	t: float,
	params: ShapeColorPostProcessingPipelineParams) -> Color:
	
	if params == null or not params.enabled:
		return src_clear_color
	
	var shape = Shape.new()
	shape.size = Vector2.ONE
	shape.tint = src_clear_color
	var shapes = execute_pipeline([shape], 0, params)
	return shapes[0].tint

static func _execute_shader(
	shapes: Array[Shape],
	shader: ShapeColorPostProcessingShader,
	t: float
) -> void:
	for i in range(shapes.size()):
		var shape = shapes[i]
		shape.tint = shader.process_color(i, t, shape)
