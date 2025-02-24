extends VBoxContainer

@export var image_processing: Node
@export var add_check_box: CheckBox
@export var load_texture_b_button: Button
@export var b_texture_rect: TextureRect
@export var image_file_dialog: FileDialog

func _ready() -> void:
	load_texture_b_button.pressed.connect(image_file_dialog.show)
	image_file_dialog.file_selected.connect(_image_selected)
	

func _process(delta: float) -> void:
	if is_visible_in_tree():
		var add_processor := image_processing.image_processor as AddImageProcessor
		add_processor.sign = 1.0 if add_check_box.button_pressed else -1.0

func _image_selected(path: String):
	
	if not is_visible_in_tree():
		return
	
	var renderer_texture = LocalTexture.load_from_path(path)
	var add_processor := image_processing.image_processor as AddImageProcessor
	add_processor.texture_b = renderer_texture
	b_texture_rect.texture = RenderingCommon.create_texture_from_rd_rid(renderer_texture.rd_rid)
