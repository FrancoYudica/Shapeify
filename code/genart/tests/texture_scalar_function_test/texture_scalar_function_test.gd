extends Node2D

@export var texture: RendererTextureLoad
@export var scalar_function_type: TextureScalarFunction.Type = TextureScalarFunction.Type.MAX

@onready var _scalar_function := TextureScalarFunction.factory_create(scalar_function_type)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var total_time_taken = 0.0
	var iterations = 100
	for i in range(iterations):
		var clock := Clock.new()
		var result = _scalar_function.evaluate(texture)
		var elapsed = clock.elapsed_ms()
		total_time_taken += elapsed
		print("Scalar function result: %s. Time taken: %s" % [result, elapsed])
		
	print("FINISHED: Total time taken: %s. Average time: %s" % [total_time_taken, total_time_taken / iterations])
