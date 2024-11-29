extends TextureRect


@onready var _individual_generation_params = Globals \
											.settings \
											.image_generator_params \
											.individual_generator_params 

func _ready() -> void:
	texture = RenderingCommon.create_texture_from_rd_rid(
		_individual_generation_params.target_texture.rd_rid)
