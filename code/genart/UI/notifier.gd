extends Node

var _panels: Dictionary = {}

func notify_info(message):
	_notify(_panels[NotificationPanel.Type.INFO], message)

func notify_warning(message):
	_notify(_panels[NotificationPanel.Type.WARNING], message)

func notify_error(message):
	_notify(_panels[NotificationPanel.Type.ERROR], message)

func _notify(panel, message):
	panel.message = message
	panel.visible = true

func add_notification_panel(
	notification_panel,
	type):
	
	_panels[type] = notification_panel
