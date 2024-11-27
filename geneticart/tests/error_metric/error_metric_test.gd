extends Node

@export var target_texture: RendererTextureLoad
@export var source_texture: RendererTextureLoad

@export var error_metric: ErrorMetric
@export var iterations = 10

func _ready() -> void:
	
	var average_error = 0.0
	var average_time = 0.0
	var f = 1.0 / iterations
	
	var t0 = Time.get_ticks_msec()
	error_metric.target_texture = target_texture
	
	for i in range(iterations):
		
		var t = Time.get_ticks_msec()
		var error = error_metric.compute(source_texture)
		average_error += f * error
		var elapsed_t = Time.get_ticks_msec() - t
		average_time += f * elapsed_t
	
	print("Executed %s iterations of error" % iterations)
	print(" - Average error: %s" % average_error)
	print(" - Average compute time taken: %sms " % average_time)
	print(" - Total time taken: %sms " % (Time.get_ticks_msec() - t0))
