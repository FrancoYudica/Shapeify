extends TextureButton

@export var animator: Node

func _ready() -> void:
	animator.animation_finished.connect(
		func():
			button_pressed = false
	)
	animator.animation_started.connect(
		func():
			button_pressed = true
	)

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		animator.play()
	else:
		animator.stop()
