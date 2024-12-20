class_name NotificationPanel extends Control

enum Type
{
	INFO,
	WARNING,
	ERROR
}

@export var message_label: Label
@export var ok_button: Button
@export var type: Type

var message: String:
	set(text):
		message = text
		message_label.text = text

func _ready() -> void:
	ok_button.pressed.connect(
		func():
			visible = false
	)
	
	Notifier.add_notification_panel(self, type)
