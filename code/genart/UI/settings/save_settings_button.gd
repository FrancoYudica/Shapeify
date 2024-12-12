extends Button


func _ready() -> void:
	pressed.connect(
		func ():
			Globals.save()
	)
