class_name TagEffector
extends Effector

# TODO: dropdown or some other picker
@export var tag : StringName

var _affected_targets : Array[Node]

func apply_effect(target: Node) -> bool:
	if _affected_targets.has(target):
		return false

	var tag_container := JamUtils.get_tag_container(target)
	if not tag_container:
		return false

	tag_container.add_tag(tag)
	_affected_targets.append(target)
	return true

func remove_effect(target: Node) -> bool:
	if not _affected_targets.has(target):
		return false

	var tag_container := JamUtils.get_tag_container(target)
	if not tag_container:
		return false

	tag_container.remove_tag(tag)
	_affected_targets.erase(target)
	return true
