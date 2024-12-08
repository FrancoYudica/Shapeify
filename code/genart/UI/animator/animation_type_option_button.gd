extends OptionButton

@export var animator: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for animation_name in IndividualAnimatorStrategy.Type.keys():
		add_item(animation_name)
		
	select(IndividualAnimatorStrategy.Type.TIMELINE)
	item_selected.connect(
		func(i):
			animator.animation_player.animator = i as IndividualAnimatorStrategy.Type
	)
