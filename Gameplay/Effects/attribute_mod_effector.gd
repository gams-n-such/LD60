class_name AttributeModEffector
extends Effector

@export var attribute_tag : Attribute.Tag
@export var mod : AttributeModInfo

var _active_modifiers : Dictionary[Node, AttributeMod]

func apply_effect(target: Node) -> bool:
	if _active_modifiers.has(target):
		return false

	var attribute := JamUtils.find_tagged_attribute(target, attribute_tag) as DynamicAttribute
	if not attribute:
		return false

	var active_mod := attribute.add_modifier(mod)
	if not active_mod:
		return false

	_active_modifiers.set(target, active_mod)
	return true

func remove_effect(target: Node) -> bool:
	if not _active_modifiers.has(target):
		return false

	var active_mod := _active_modifiers[target]
	if not active_mod:
		return false

	_active_modifiers.erase(target)
	active_mod.remove()
	return true
