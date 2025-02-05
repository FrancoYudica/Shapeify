## Script that only displays the given UI item if the type matches
## This way the Grid container items after selecting the type are aligned
extends Node

@export var type: StopCondition.Type
@export var ui_items: Array[Control]

var _params : ImageGeneratorParams:
	get:
		return Globals.settings.image_generator_params

func _process(delta: float) -> void:
	
	var enabled = type == _params.stop_condition
	
	for item in ui_items:
		item.visible = enabled
