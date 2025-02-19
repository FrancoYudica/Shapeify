extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child: Control in get_children():
		child.visibility_changed.connect(_child_visibility_changed)


func _child_visibility_changed():
	
	var any_visible = false
	for child in get_children():
		if child.visible:
			any_visible = true
	
	# Only visible if there is any child visible
	visible = any_visible
	
