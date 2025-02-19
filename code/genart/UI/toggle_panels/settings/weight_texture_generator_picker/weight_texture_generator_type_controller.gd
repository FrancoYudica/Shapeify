## Script that only displays the given UI item if the type matches
## This way the Grid container items after selecting the type are aligned
extends Node

@export var type: WeightTextureGenerator.Type
@export var ui_items: Array[Control]

func _process(delta: float) -> void:
	
	var params := Globals \
				.settings \
				.image_generator_params \
				.weight_texture_generator_params
	
	var enabled = type == params.weight_texture_generator_type
	
	for item in ui_items:
		item.visible = enabled
