extends SpinBox

@export var animator: Node

func _ready() -> void:
	value_changed.connect(
		func(value):
			animator.duration = value
	)
