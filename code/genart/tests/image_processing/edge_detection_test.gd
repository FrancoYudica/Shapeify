extends Control

@export var process_script: GDScript
@export var textures: Array[RendererTexture]
@onready var output_Texture_rect := $TextureRect

var edge_detection: SobelEdgeDetectionImageProcessor

func _ready() -> void:
	edge_detection = process_script.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var texture = textures[0]
	
	var clock = Clock.new()
	var processed_texture = edge_detection.process_image(texture)
	print("Time taken: %s" % clock.elapsed_ms())

	Renderer.begin_frame(processed_texture.get_size())
	
	Renderer.render_sprite(
		texture.get_size() * 0.5,
		texture.get_size(),
		0.0,
		Color.WHITE,
		processed_texture
	)
	
	Renderer.end_frame()
	output_Texture_rect.update_texture()


func _on_change_texture_button_pressed() -> void:
	var first = textures.pop_at(0)
	textures.append(first)


func _on_threshold_spin_box_value_changed(value: float) -> void:
	edge_detection.threshold = value


func _on_power_spin_box_value_changed(value: float) -> void:
	edge_detection.power = value
