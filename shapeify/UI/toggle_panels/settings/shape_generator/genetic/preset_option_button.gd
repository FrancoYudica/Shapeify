## Script that only displays the given UI item if the type matches
## This way the Grid container items after selecting the type are aligned
extends Node

@export var type: SurvivorSelectionStrategy.Type
@export var ui_items: Array[Control]

var _params : ImageGeneratorParams:
	get:
		return Globals.settings.image_generator_params

func _process(delta: float) -> void:
	
	var genetic = _params.shape_generator_type == ShapeGenerator.Type.Genetic
	var selected_strategy = type == _params.shape_generator_params.genetic_params.survivor_selection_strategy
	var enabled = genetic and selected_strategy
	
	for item in ui_items:
		item.visible = enabled
