extends GridContainer


@export var animator: Node
@export var scale_spin_box: SpinBox
@export var resolution_label: Label
@export var final_resolution_label: Label
@export var format_option_button: OptionButton

var frame_saver_type: FrameSaver.Type:
	get:
		return format_option_button.selected as FrameSaver.Type
		
var render_scale: float:
	get:
		return scale_spin_box.value

var target_texture_size: Vector2i:
	get:
		return Globals.settings.image_generator_params.target_texture.get_size()

func _ready() -> void:
	scale_spin_box.value_changed.connect(
		func(value):
			final_resolution_label.text = "%sx%s" % [
				int(target_texture_size.x * scale_spin_box.value),
				int(target_texture_size.y * scale_spin_box.value)]
	)
	
	for item in FrameSaver.Type.keys():
		format_option_button.add_item(item)
	
	format_option_button.select(0)
	visibility_changed.connect(
		func():
			if not visible:
				return

			final_resolution_label.text = "%sx%s" % [
				int(target_texture_size.x * scale_spin_box.value),
				int(target_texture_size.y * scale_spin_box.value)]
			
			resolution_label.text = "%sx%s" % [
				int(target_texture_size.x),
				int(target_texture_size.y)]
	)
