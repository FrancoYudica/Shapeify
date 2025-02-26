extends CanvasLayer

@export var shape_generator_params: ShapeGeneratorParams
@export var target_texture: Texture2D
@export var output_texture: TextureRect
@export var generate_button: Button
@export var save_button: Button
@export var shape_generator_option: OptionButton
@export var profiling_depth_option_button: OptionButton
@export var count_spin_box: SpinBox
@export var output_label: Label
@export var weight_generator_option: OptionButton
@export var _output_texture_rect: TextureRect

var _source_texture: LocalTexture
var _target_texture: LocalTexture
var _shape_generator: ShapeGenerator
var _weight_texture_generator: WeightTextureGenerator


func _ready() -> void:
	
	# shape generator option -----------------------------------------------
	for generator in ShapeGenerator.Type.keys():
		shape_generator_option.add_item(generator)
	shape_generator_option.select(ShapeGenerator.Type.Genetic)
	shape_generator_option.item_selected.connect(
		func(i):
			_set_shape_generator(i as ShapeGenerator.Type)
	)
	# Profiling depth option ---------------------------------------------------
	for depth in Profiler.Depth.keys():
		profiling_depth_option_button.add_item(depth)
	profiling_depth_option_button.select(Profiler.depth)
	profiling_depth_option_button.item_selected.connect(
		func(i):
			Profiler.depth = i as Profiler.Depth
	)

	# Weight texture generator option ---------------------------------------------------
	for generator in WeightTextureGenerator.Type.keys():
		weight_generator_option.add_item(generator)
	weight_generator_option.select(WeightTextureGenerator.Type.WHITE)
	weight_generator_option.item_selected.connect(
		func(i):
			_weight_texture_generator = WeightTextureGenerator.factory_create(i)
	)
	_weight_texture_generator = WeightTextureGenerator.factory_create(WeightTextureGenerator.Type.WHITE)
	
	# Creates source texture
	var source_color = Color.BLACK
	GenerationGlobals.renderer.begin_frame(target_texture.get_size())
	GenerationGlobals.renderer.render_clear(source_color)
	GenerationGlobals.renderer.end_frame()
	_source_texture = GenerationGlobals.renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.COLOR).copy()
	_target_texture = LocalTexture.load_from_texture(target_texture, GenerationGlobals.renderer.rd)



	# Sets shape generator
	_set_shape_generator(ShapeGenerator.Type.Genetic)
	
func generate() -> void:

	_shape_generator.target_texture = _target_texture
	_shape_generator.source_texture = _source_texture
	_shape_generator.setup()
	
	output_label.call_deferred("set_text", "Generation started")

	generate_button.call_deferred("set_disabled", true)
	for i in range(int(count_spin_box.value)):
		

		_shape_generator.weight_texture = _weight_texture_generator.generate(0, _target_texture, _source_texture)
		
		var clock = Clock.new()
		var shape = _shape_generator.generate_shape(0.0)
		output_label.call_deferred(
			"set_text", 
			"%s. Generated shape in %sms" % [i, clock.elapsed_ms()]
		)
		# Renders the best shape
		ShapeRenderer.render_shape(
			GenerationGlobals.renderer,
			_source_texture,
			shape
		)
		_output_texture_rect.texture = GenerationGlobals.renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.COLOR).create_texture_2d_rd()
	
	output_label.call_deferred("set_text", "Generation finished")
	generate_button.call_deferred("set_disabled", false)
	
	_shape_generator.finished()
	

func _on_button_pressed() -> void:
	WorkerThreadPool.add_task(generate)


func _on_profiling_check_box_toggled(toggled_on: bool) -> void:
	save_button.disabled = not toggled_on
	if toggled_on:
		Profiler.start_profiling()
	else:
		Profiler.stop_profiling()
		

func _on_save_profiling_button_pressed() -> void:
	Profiler.save()
	_save_output()
	print("Output saved")

func _set_shape_generator(type: ShapeGenerator.Type):
	# Setup shape generator -----------------------------------------------
	_shape_generator = ShapeGenerator.factory_create(type)
	_shape_generator.params = shape_generator_params

func _save_output():
	var color_attachment_texture = GenerationGlobals.renderer.get_attachment_texture(LocalRenderer.FramebufferAttachment.COLOR)
	var color_attachment_data = GenerationGlobals.algorithm_rd.texture_get_data(color_attachment_texture.rd_rid, 0)
	
	# Creates an image with the same size and format
	var img = Image.new()
	img.set_data(
		color_attachment_texture.get_width(),
		color_attachment_texture.get_height(),
		false,
		Image.Format.FORMAT_RGBAF,
		color_attachment_data)
	
	img.save_png("res://out/out.png")
