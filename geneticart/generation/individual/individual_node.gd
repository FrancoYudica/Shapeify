class_name IndividualNode extends TextureRect


static func apply_genetic_attributes(
	individual_node: IndividualNode,
	attributes: Individual):
	individual_node.position = attributes.position
	individual_node.scale = attributes.size
	individual_node.rotation = attributes.rotation
	individual_node.texture = attributes.texture
	individual_node.modulate = attributes.tint
