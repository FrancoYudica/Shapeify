extends TextureButton

@export var animator: Node
@export var recording_panel: Control

var _animation_recorder := AnimationVideoRecorder.new()

func _ready() -> void:
	
	_animation_recorder.recorded.connect(
		func(saved_path: String):
			print("Frames saved at: %s" % saved_path)
			recording_panel.visible = false
	)
	
	pressed.connect(
		func():
			_animation_recorder.duration = animator.duration
			_animation_recorder.record(
				animator.animation_player,
				animator.image_generation_details
			)
			recording_panel.visible = true
	)
