extends HBoxContainer

@export var contributor_name: String
@export var contact_uri: String

@onready var _link_button := $LinkButton

func _ready() -> void:
	_link_button.text = contributor_name
	_link_button.uri = contact_uri
