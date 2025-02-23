extends HBoxContainer

@export var contributors_container: Control

var contributor_scene = load("res://UI/popup/program_info/contributor_item.tscn")

func _ready() -> void:
	
	for contributor in Globals.settings.contributors:
		var contributor_item = contributor_scene.instantiate()
		contributor_item.contributor_name = contributor.contributor_name
		contributor_item.contact_uri = contributor.contact_uri
		contributors_container.add_child(contributor_item)
	
