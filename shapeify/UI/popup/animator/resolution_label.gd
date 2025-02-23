extends Label

@export var animator: Control

func _process(delta: float) -> void:
	if is_visible_in_tree():
		text = "%sx%s" % [
			animator.image_generation_details.viewport_size.x,
			animator.image_generation_details.viewport_size.y
		]
