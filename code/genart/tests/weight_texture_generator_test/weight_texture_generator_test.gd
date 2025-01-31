extends Control

@export var target_texture: RendererTextureLoad
@export var source_texture: RendererTextureLoad
@export var target_texture_rect: TextureRect
@export var out_texture_rect: TextureRect
@export var generate_button: Button
@export var generator_type_option_button: OptionButton
@export var progress_spin_box: SpinBox
@export var time_taken_label: Label

var texture_generator: WeightTextureGenerator

func _ready() -> void:
	
	texture_generator = WeightTextureGenerator.factory_create(WeightTextureGenerator.Type.WHITE)
	
	target_texture_rect.texture = RenderingCommon.create_texture_from_rd_rid(target_texture.rd_rid)
	out_texture_rect.texture = RenderingCommon.create_texture_from_rd_rid(target_texture.rd_rid)
	
	# Generator option button --------------------------------------------------
	for type_name in WeightTextureGenerator.Type.keys():
		generator_type_option_button.add_item(type_name)
		
	generator_type_option_button.select(0)
	generator_type_option_button.item_selected.connect(
		func(i):
			texture_generator = WeightTextureGenerator.factory_create(i)
	)
	
	generate_button.pressed.connect(
		func():
			var clock := Clock.new()
			var texture = texture_generator.generate(
				progress_spin_box.value,
				target_texture,
				source_texture
			)
			var elapsed = clock.elapsed_ms()
			time_taken_label.text = "Generation time taken: %s" % elapsed
			out_texture_rect.texture = RenderingCommon.create_texture_from_rd_rid(texture.rd_rid)
	)
