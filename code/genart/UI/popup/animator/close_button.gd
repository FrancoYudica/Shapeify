extends Button

@export var animator: Control

func _ready() -> void:
	pressed.connect(
		func():
			animator.visible = false
	)
