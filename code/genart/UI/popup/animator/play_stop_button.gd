extends Button

@export var animator: Node
@export var play_icon: Texture2D
@export var stop_icon: Texture2D

func _ready() -> void:
	animator.animation_finished.connect(
		func():
			set_pressed_no_signal(false)
			icon = play_icon
	)
	animator.animation_started.connect(
		func():
			set_pressed_no_signal(true)
			icon = stop_icon
	)
	
	toggled.connect(_on_toggled)

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		animator.play()
		icon = stop_icon
	else:
		animator.stop()
		icon = play_icon
