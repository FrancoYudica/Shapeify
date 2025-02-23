extends HSlider

@export var animator: Node

func _ready() -> void:
	animator.animation_progress_updated.connect(
		func(t):
			set_value_no_signal(t)
	)


func _on_value_changed(value: float) -> void:
	animator.set_frame(value)
