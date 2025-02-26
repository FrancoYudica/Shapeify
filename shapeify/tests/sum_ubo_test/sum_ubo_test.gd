extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var processor = load("res://generation/partial_metric/mpa/sum_uniform_buffer.gd").new()
	
		# Initializes input buffer
	var input = PackedFloat32Array()
	input.resize(512)
	input.fill(1)
	
	var input_bytes = input.to_byte_array()
	var _rd = GenerationGlobals.renderer.rd
	var input_storage_buffer = _rd.storage_buffer_create(
		input_bytes.size(),
		input_bytes)
	
	for i in range(100):
		var clock := Clock.new()
		var result = processor.compute(input_storage_buffer, 256)
		clock.print_elapsed("Result %s calculated in: " % result)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
