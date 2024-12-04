extends PanelContainer

@export var profile: CheckBox
@export var save_button: Button

func _ready() -> void:
	profile.button_pressed = false
	profile.toggled.connect(
		func(toggled_on):
			if toggled_on:
				Profiler.start_profiling()
				save_button.disabled = false
				
			else:
				Profiler.stop_profiling()
				save_button.disabled = true
	)
	
	save_button.disabled = true
	save_button.pressed.connect(
		func():
			Profiler.save()
	)
