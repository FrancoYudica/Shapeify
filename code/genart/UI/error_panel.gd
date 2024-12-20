extends Control

@export var message_label: Label

var message: String:
	set(text):
		message = text
		message_label.text = text

func _ready() -> void:
	Globals.error_notification = self

func _on_ok_button_pressed() -> void:
	visible = false
