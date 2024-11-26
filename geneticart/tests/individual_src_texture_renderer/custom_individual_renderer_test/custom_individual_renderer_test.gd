extends Node

@export var individual_renderer: IndividualRenderer
@export var individual: Individual


func _process(delta: float) -> void:
	individual_renderer.render_individual(individual)
