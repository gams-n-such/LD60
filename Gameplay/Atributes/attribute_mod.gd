class_name AttributeMod
extends Node

@export var info : AttributeModInfo

var attribute : DynamicAttribute:
	get:
		return get_parent() as DynamicAttribute

var type : AttributeModInfo.ModType:
	get:
		return info.mod_type

var value : float:
	get:
		return info.mod_value

func remove() -> void:
	if attribute:
		attribute.remove_modifier(self)

func _enter_tree() -> void:
	assert(get_parent() is DynamicAttribute, "AttributeMods are only supported by DynamicAttributes, but parent is " + str(get_parent().get_class()))
