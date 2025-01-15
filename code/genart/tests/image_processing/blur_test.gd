extends Control

@export var blur_script: GDScript
@export var blur_textures: Array[RendererTexture]
@onready var output_Texture_rect := $TextureRect

var blur: GaussianBlurImageProcessor

func _ready() -> void:
	blur = blur_script.new()
	blur.iterations = 10
	blur.kernel_size = 5
	blur.sigma = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var blur_texture = blur_textures[0]
	
	var clock = Clock.new()
	var blurred = blur.process_image(blur_texture)
	print("Blur time taken: %s" % clock.elapsed_ms())

	Renderer.begin_frame(blur_texture.get_size())
	
	Renderer.render_sprite(
		blur_texture.get_size() * 0.5,
		blur_texture.get_size(),
		0.0,
		Color.WHITE,
		blurred
	)
	
	Renderer.end_frame()
	output_Texture_rect.update_texture()


func _on_change_texture_button_pressed() -> void:
	var first = blur_textures.pop_at(0)
	blur_textures.append(first)


func _on_iterations_spin_box_value_changed(value: float) -> void:
	blur.iterations = value

func _on_kernel_size_spin_box_value_changed(value: float) -> void:
	blur.kernel_size = value

func _on_sigma_spin_box_value_changed(value: float) -> void:
	blur.sigma = value
