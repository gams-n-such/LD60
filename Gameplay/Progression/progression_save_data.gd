class_name ProgressionSaveData
extends Resource

var attribute_levels : Dictionary[Attribute.Tag, int]

func reset() -> void:
	attribute_levels.clear()

func get_attribute_level(attribute : Attribute.Tag) -> int:
	if attribute_levels.has(attribute):
		return attribute_levels[attribute]
	else:
		return -1
