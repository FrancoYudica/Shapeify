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

func _ready() -> void:
	scale_spin_box.value_changed.connect(
		func(value):
			final_resolution_label.text = "%sx%s" % [
				int(animator.image_generation_details.viewport_size.x * scale_spin_box.value),
				int(animator.image_generation_details.viewport_size.y * scale_spin_box.value)]
	)
	
	for item in FrameSaver.Type.keys():
		format_option_button.add_item(item)
	
	format_option_button.select(0)
	visibility_changed.connect(
		func():
			if not visible:
				return

			final_resolution_label.text = "%sx%s" % [
				int(animator.image_generation_details.viewport_size.x * scale_spin_box.value),
				int(animator.image_generation_details.viewport_size.y * scale_spin_box.value)]
			
			resolution_label.text = "%sx%s" % [
				int(animator.image_generation_details.viewport_size.x),
				int(animator.image_generation_details.viewport_size.y)]
	)
