# An algorithm that, given a set of parameters, a target texture, and a source texture, 
# generates the best possible individual. This individual, when added to the source texture, 
# minimizes the error metric relative to the target texture.
class_name IndividualGenerator extends Node

@export_category("Data")
@export var target_texture: Texture2D = null
var target_texture_rd_rid: RID
var source_texture_rd_rid: RID

## If source texture is null, a black texture will be generated
@export var source_texture: Texture2D = null

@export_category("Algorithm components")
@export var average_color_sampler: AverageColorSampler
@export var fitness_calculator: FitnessCalculator
@export var individual_renderer: IndividualRenderer
@export var populator: Populator

var _initialized = false

func initialize():
	
	if target_texture == null:
		printerr("Trying to initialize IndividualGenerator but target_texture is null")
		return
		
	if source_texture == null:
		_initialize_src_image()
	
	fitness_calculator.target_texture_rd_rid = target_texture_rd_rid
	average_color_sampler.sample_texture = target_texture
	
	_initialized = true


func generate_individual(params: IndividualGeneratorParams) -> Individual:
	
	if not _initialized:
		printerr("IndividialGenerator not initialized")
		return
	
	_setup(params)
	return await _generate(params)

func _setup(params: IndividualGeneratorParams):
	individual_renderer.clear_signals()
	individual_renderer.source_texture_rd_rid = source_texture_rd_rid

func _generate(params: IndividualGeneratorParams) -> Individual:
	return

func _initialize_src_image():
	var img = Image.create(
		target_texture.get_width(), 
		target_texture.get_height(), 
		false, 
		Image.FORMAT_RGBA8)
	img.fill(Color.BLACK)
	source_texture = ImageTexture.create_from_image(img)
	source_texture_rd_rid = RenderingCommon.create_local_rd_texture_copy(source_texture)
