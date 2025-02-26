extends Control

@export var cpu_sampler_script: GDScript
@export var compute_sampler_script: GDScript

var average_color_sampler: AverageColorSampler
var cpu_sampler: AverageColorSampler
var compute_sampler: AverageColorSampler
@export var compare_results: bool

@onready var sub_viewport := $SubViewportContainer/SubViewport
@onready var sample_color_rect := $OutlineColorRect/SampleColorRect
@onready var parent_color_rect := $OutlineColorRect

var _sample_texure: LocalTexture

func _ready() -> void:
	
	cpu_sampler = cpu_sampler_script.new()
	compute_sampler = compute_sampler_script.new()
	average_color_sampler = compute_sampler

	
func _process(delta: float) -> void:
	var texture = sub_viewport.get_texture()
	_sample_texure = LocalTexture.load_from_texture(texture, GenerationGlobals.renderer.rd)
	average_color_sampler.sample_texture = _sample_texure
	cpu_sampler.sample_texture = _sample_texure
	compute_sampler.sample_texture = _sample_texure
	
	var rect: Rect2i
	var mouse = get_local_mouse_position()
	rect.position = Vector2i(mouse.x, mouse.y)
	rect.size = Vector2i(
		sample_color_rect.get_global_rect().size.x,
		sample_color_rect.get_global_rect().size.y)
	
	if not compare_results:
		
		var clock = Clock.new()
		var color = average_color_sampler.sample_rect(rect)
		clock.print_elapsed("Sampled average color: %s" % color)
		
		parent_color_rect.position = mouse
		sample_color_rect.color = color
	
	else:
		var clock = Clock.new()
		var cpu_color = cpu_sampler.sample_rect(rect)
		var dt0 = clock.elapsed_ms()
		clock.print_elapsed("CPU sampled color: %s" % cpu_color)
		
		clock.restart()
		var compute_color = compute_sampler.sample_rect(rect)
		var dt1 = clock.elapsed_ms()
		clock.print_elapsed("GPU sampled color: %s" % compute_color)
		
		print("Compute speedup: %s" % [dt0 / dt1])
		parent_color_rect.position = mouse
		sample_color_rect.color = compute_color
