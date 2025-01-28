extends CanvasLayer

@export var texture: RendererTextureLoad
@export var time_taken_label: Label
@export var output_texture_rect: TextureRect
@export var processor_option_button: OptionButton

var image_processor: ImageProcessor

var processor_type: ImageProcessor.Type:
	get:
		return processor_option_button.selected as ImageProcessor.Type

func _ready() -> void:
	for key in ImageProcessor.Type.keys():
		processor_option_button.add_item(key)
	
	processor_option_button.select(0)
	image_processor = ImageProcessor.factory_create(ImageProcessor.Type.values()[0])
	
	processor_option_button.item_selected.connect(
		func(item):
			image_processor = ImageProcessor.factory_create(item)
	)

func _process_image() -> void:
	
	var clock := Clock.new()
	var output_texture: RendererTexture = image_processor.process_image(texture)
	time_taken_label.text = "Time taken %sms" % clock.elapsed_ms()
	
	var previous_texture = output_texture_rect.texture
	output_texture_rect.texture = null
	
	if previous_texture != null:
		RenderingServer.get_rendering_device().free_rid(previous_texture.texture_rd_rid)
	
	output_texture_rect.texture = RenderingCommon.create_texture_from_rd_rid(output_texture.rd_rid)

func _process(delta: float) -> void:
	_process_image()
