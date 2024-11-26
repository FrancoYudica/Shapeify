extends Node

@export var target_texture: Texture
@export var source_texture: Texture

@export var error_metric: ErrorMetric
@export var iterations = 10

func _ready() -> void:
	
	var target_texture_rd_rid = RenderingCommon.create_local_rd_texture_copy(target_texture)
	var source_texture_rd_rid = RenderingCommon.create_local_rd_texture_copy(source_texture)
	
	var average_error = 0.0
	var average_time = 0.0
	var f = 1.0 / iterations
	
	var t0 = Time.get_ticks_msec()
	error_metric.target_texture_rd_rid = target_texture_rd_rid
	
	for i in range(iterations):
		
		var t = Time.get_ticks_msec()
		var error = error_metric.compute(source_texture_rd_rid)
		average_error += f * error
		var elapsed_t = Time.get_ticks_msec() - t
		average_time += f * elapsed_t
	
	print("Executed %s iterations of error" % iterations)
	print(" - Average error: %s" % average_error)
	print(" - Average compute time taken: %sms " % average_time)
	print(" - Total time taken: %sms " % (Time.get_ticks_msec() - t0))
