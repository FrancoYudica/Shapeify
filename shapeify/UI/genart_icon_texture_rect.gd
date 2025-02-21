extends PanelContainer

@export var toggle_panel: Control

@onready var animation_player = $AnimationPlayer
@onready var button = $MarginContainer/Button

func _ready() -> void:
	mouse_entered.connect(
		func():
			animation_player.play("mouse_hover")
	)
	mouse_exited.connect(
		func():
			
			if ImageGeneration.is_generating:
				animation_player.play("generation_started")
			else:
				animation_player.play("mouse_hover_lost")
	)
	
	ImageGeneration.generation_started.connect(
		func():
			animation_player.play("generation_started")
	)

	ImageGeneration.generation_finished.connect(
		func():
			animation_player.play("generation_finished")
	)

	button.pressed.connect(
		func():
			toggle_panel.visible = not toggle_panel.visible
	)
