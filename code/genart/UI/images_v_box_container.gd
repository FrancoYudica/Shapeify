extends VBoxContainer

@export var rotate_button: Button
@export var container1: Control
@export var container2: Control

func _ready() -> void:
	rotate_button.pressed.connect(
		func():
			
			# Swaps the childs
			if not container1.visible:
				_transfer_childs(container2, container1)
			else:
				_transfer_childs(container1, container2)
			
			container1.visible = not container1.visible
			container2.visible = not container2.visible
	)

func _transfer_childs(src: Control, dst: Control):
	var childs = src.get_children()
	
	for child in childs:
		child.reparent(dst)
