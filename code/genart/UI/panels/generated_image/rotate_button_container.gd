extends Button

@export var split_container: SplitContainer

func _ready() -> void:
	pressed.connect(
		func():
			split_container.vertical = not split_container.vertical
	)
