class_name AttributeProgressionInfo
extends Resource


@export var target_attribute : Attribute.Tag
@export var levels : Array[AttributeProgressionLevelInfo]

var max_level : int:
	get:
		return levels.size() - 1
