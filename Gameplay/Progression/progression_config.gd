# TODO: implement curve-based progression
class_name ProgressionConfig
extends Resource

@export var attribute_progressions : Array[AttributeProgressionInfo]

func get_progression_for_attribute(attribute : Attribute.Tag) -> AttributeProgressionInfo:
	for branch in attribute_progressions:
		if branch.target_attribute == attribute:
			return branch
	return null
