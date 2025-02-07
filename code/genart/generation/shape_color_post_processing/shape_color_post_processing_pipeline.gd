## Executes a sequence of color post processing shaders
class_name ShapeColorPostProcessingPipeline extends RefCounted


func execute_pipeline(
	shapes: Array[Shape],
	t: float,
	params: Array[ShapeColorPostProcessingShaderParams]
) -> Array[Shape]:
	
	# Duplicates shapes to avoild accumulating the post processing effect over
	# multiple executions of `execute_pipeline()`
	var duplicated_shapes: Array[Shape] = []
	for shape in shapes:
		duplicated_shapes.append(shape.copy())
	
	for param in params:
		
		# Creates the shader
		var shader := ShapeColorPostProcessingShader.factory_create(param.type)
		
		# Sets parameters and executes
		shader.set_params(param)
		_execute_shader(duplicated_shapes, shader, t)
		
	return duplicated_shapes
	
func _execute_shader(
	shapes: Array[Shape],
	shader: ShapeColorPostProcessingShader,
	t: float
) -> void:
	for i in range(shapes.size()):
		var shape = shapes[i]
		shape.tint = shader.process_color(i, t, shape)
