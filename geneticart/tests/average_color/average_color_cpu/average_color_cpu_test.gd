extends Control

@export var average_color_sampler: AverageColorSampler

@export var cpu_sampler: AverageColorSampler
@export var compute_sampler: AverageColorSampler

@export var compare_results: bool

@onready var sub_viewport := $SubViewportContainer/SubViewport
@onready var sample_color_rect := $OutlineColorRect/SampleColorRect
@onready var parent_color_rect := $OutlineColorRect

func _ready() -> void:
	RenderingServer.frame_post_draw.connect(_frame_post_draw)
	
func _frame_post_draw() -> void:
	
	if average_color_sampler.sample_texture == null:
		print("Updai")
		var texture = sub_viewport.get_texture()
		average_color_sampler.sample_texture = texture
		cpu_sampler.sample_texture = texture
		compute_sampler.sample_texture = texture
	
	var rect: Rect2i
	var mouse = get_local_mouse_position()
	rect.position = Vector2i(mouse.x, mouse.y)
	rect.size = Vector2i(
		sample_color_rect.get_global_rect().size.x,
		sample_color_rect.get_global_rect().size.y)
	
	if not compare_results:
		var t = Time.get_ticks_usec()
		var color = average_color_sampler.sample_rect(rect)
		var dt_ms = (Time.get_ticks_usec() - t) / 1000.0
		print("Sampled average color: %s. Elapsed %sms" % [color, dt_ms])
		
		parent_color_rect.position = mouse
		sample_color_rect.color = color
	
	else:
		var t = Time.get_ticks_usec()
		var cpu_color = cpu_sampler.sample_rect(rect)
		var cpu_dt_ms = (Time.get_ticks_usec() - t) / 1000.0
		
		t = Time.get_ticks_usec()
		var compute_color = compute_sampler.sample_rect(rect)
		var compute_dt_ms = (Time.get_ticks_usec() - t) / 1000.0
		
		print("CPU sampled color: %s. Elapsed %sms" % [cpu_color, cpu_dt_ms])
		print("GPU sampled color: %s. Elapsed %sms" % [compute_color, compute_dt_ms])
		print("Compute speedup: %s" % [cpu_dt_ms / compute_dt_ms])
		parent_color_rect.position = mouse
		sample_color_rect.color = compute_color
