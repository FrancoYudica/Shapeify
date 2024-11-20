extends Node

@export var target_texture: Texture
@export var source_texture: Texture

@onready var image_mse_compute := $ImageMSECompute

func _ready() -> void:
	
	var average_mse = 0.0
	var average_time = 0.0
	var iterations = 1000
	var f = 1.0 / iterations
	
	var t0 = Time.get_ticks_msec()
	image_mse_compute.target_texture = target_texture
	
	for i in range(iterations):
		
		var t = Time.get_ticks_msec()
		var mse = image_mse_compute.compute(source_texture)
		average_mse += f * mse
		var elapsed_t = Time.get_ticks_msec() - t
		average_time += f * elapsed_t
	
	print("Executed %s iterations of MSE" % iterations)
	print(" - Average MSE: %s" % average_mse)
	print(" - Average compute time taken: %sms " % average_time)
	print(" - Total time taken: %sms " % (Time.get_ticks_msec() - t0))
