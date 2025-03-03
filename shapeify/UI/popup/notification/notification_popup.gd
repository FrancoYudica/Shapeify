class_name NotificationPopup extends Control

enum Type
{
	INFO,
	WARNING,
	ERROR
}

@export var message_label: Label
@export var ok_button: Button
@export var copy_button: Button
@export var type: Type

var message: String:
	set(text):
		message = text
		message_label.text = text

var clipboard_text: String

func _ready() -> void:
	ok_button.pressed.connect(
		func():
			visible = false
	)
	copy_button.pressed.connect(
		func():
			DisplayServer.clipboard_set(clipboard_text)
	)
	
	visibility_changed.connect(
		func():
			copy_button.visible = visible and not clipboard_text.is_empty()
			copy_button.tooltip_text = clipboard_text
	)
	
	Notifier.add_notification_panel(self, type)
