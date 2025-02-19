extends Node

var _panels: Dictionary = {}

func notify_info(message, clipboard=""):
	_notify(_panels[NotificationPopup.Type.INFO], message, clipboard)

func notify_warning(message, clipboard=""):
	_notify(_panels[NotificationPopup.Type.WARNING], message, clipboard)

func notify_error(message, clipboard=""):
	_notify(_panels[NotificationPopup.Type.ERROR], message, clipboard)

func _notify(panel, message, clipboard):
	panel.message = message
	panel.clipboard_text = clipboard
	panel.visible = true

func add_notification_panel(
	notification_panel,
	type):
	
	_panels[type] = notification_panel
