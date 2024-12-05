extends PopupPanel


@onready var text_label := $MarginContainer/VBoxContainer/Label

@export var text: String:
	set(value):
		text_label.text = value
		text = value
