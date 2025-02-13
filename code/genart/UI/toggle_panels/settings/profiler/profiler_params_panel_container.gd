extends PanelContainer

@export var profile: CheckBox
@export var save_button: Button
@export var profile_depth: OptionButton

func _ready() -> void:
	profile.button_pressed = false
	profile.toggled.connect(
		func(toggled_on):
			if toggled_on:
				Profiler.start_profiling()
				save_button.disabled = false
				profile_depth.disabled = false
				
				
			else:
				Profiler.stop_profiling()
				save_button.disabled = true
				profile_depth.disabled = true
				
	)
	 
	save_button.disabled = true
	save_button.pressed.connect(
		func():
			Profiler.save()
	)

	# Profile depth ------------------------------------------------------------
	profile_depth.disabled = true
	for option in Profiler.Depth.keys():
		profile_depth.add_item(option)
		
	profile_depth.select(Profiler.depth)
	profile_depth.item_selected.connect(
		func(index):
			Profiler.depth = index as Profiler.Depth
	)
	
