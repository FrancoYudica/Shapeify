extends VBoxContainer

@export var image_processing: Node
@export var power_spin_box: SpinBox
@export var load_texture_b_button: Button
@export var src_texture_rect: TextureRect
@export var image_file_dialog: FileDialog

func _ready() -> void:
	load_texture_b_button.pressed.connect(image_file_dialog.show)
	image_file_dialog.file_selected.connect(_image_selected)
	

func _process(delta: float) -> void:
	if is_visible_in_tree():
		var mpa_processor := image_processing.image_processor as MPAImageProcessor
		mpa_processor.power = power_spin_box.value


func _image_selected(path: String):
	
	if not is_visible_in_tree():
		return

	var renderer_texture = RendererTexture.load_from_path(path)
	var mpa_processor := image_processing.image_processor as MPAImageProcessor
	mpa_processor.src_texture = renderer_texture
	src_texture_rect.texture = RenderingCommon.create_texture_from_rd_rid(renderer_texture.rd_rid)
