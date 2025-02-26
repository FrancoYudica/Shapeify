extends CanvasLayer

@export var weight_texture: Texture2D
@export var weight_texture_rect: TextureRect
@export var sampler_type_option_btn: OptionButton
@export var sample_texture_rect: TextureRect
@export var generate_sample_btn: Button
@export var clear_samples_btn: Button
@export var samples_container: Control
@export var debug_label: Label
@export var sample_count_spin_box: SpinBox

var texture_position_sampler: TexturePositionSampler
@onready var _local_weight_texture = LocalTexture.load_from_texture(weight_texture, GenerationGlobals.renderer.rd)

func _ready() -> void:
	for type in TexturePositionSampler.Type.keys():
		sampler_type_option_btn.add_item(type)
	sampler_type_option_btn.select(0)
	_create_sampler(0)
	
	sampler_type_option_btn.item_selected.connect(
		func(index):
			_create_sampler(index)
	)
	
	weight_texture_rect.texture = weight_texture
	
	generate_sample_btn.pressed.connect(
		func():
			for i in range(sample_count_spin_box.value):
				_generate_sample()
	)
	
	clear_samples_btn.pressed.connect(_clear_samples)
	

func _create_sampler(type):
	texture_position_sampler = TexturePositionSampler.factory_create(type)
	
	# The texture weight texture could be directly the weight texture attribute
	# but it's important to test that the output of the renderer is in the correct format
	var renderer := GenerationGlobals.renderer
	renderer.begin_frame(weight_texture.get_size())
	renderer.render_sprite(
		weight_texture.get_size() * 0.5,
		weight_texture.get_size(),
		0,
		Color.WHITE,
		_local_weight_texture,
		0)
	renderer.end_frame()
	
	# Creates a copy of the rendered texture
	texture_position_sampler.weight_texture = renderer.get_attachment_texture(
		LocalRenderer.FramebufferAttachment.COLOR
	).copy()

func _generate_sample():
	
	var clock := Clock.new()
	var local_position = texture_position_sampler.sample()
	var elapsed = clock.elapsed_ms()
	debug_label.text = "Generated position: %s. Time taken: %sms" % [local_position, elapsed]
	var global_rect = weight_texture_rect.get_global_rect()
	
	# Maps local position to global position
	var normalized_local_position = Vector2(
		float(local_position.x) / weight_texture.get_width(),
		float(local_position.y) / weight_texture.get_height()
	)
	
	var mapped_local_position = normalized_local_position * global_rect.size
	var global_position = global_rect.position + mapped_local_position
	
	var new_sample_texture_rect = sample_texture_rect.duplicate()
	new_sample_texture_rect.visible = true
	new_sample_texture_rect.global_position = global_position - new_sample_texture_rect.get_global_rect().size * 0.5
	samples_container.add_child(new_sample_texture_rect)

func _clear_samples():
	for sample in samples_container.get_children():
		samples_container.remove_child(sample)
