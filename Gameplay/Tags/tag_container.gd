# TODO: track source objects
class_name TagContainer
extends Node

var _tags_count : Dictionary[StringName, int]

func has_tag(tag: StringName) -> bool:
	return get_tag_count(tag) > 0

func get_tag_count(tag: StringName) -> int:
	if _tags_count.has(tag):
		return _tags_count[tag]
	else:
		return 0

func add_tag(tag: StringName, count: int = 1) -> int:
	if count > 0: 
		if _tags_count.has(tag):
			_tags_count[tag] += count
		else:
			_tags_count.set(tag, count)
	return get_tag_count(tag)

func remove_tag(tag: StringName, count: int = 1) -> int:
	if count > 0:
		var current_count := get_tag_count(tag)
		if current_count > count:
			_tags_count[tag] -= count
		else:
			_tags_count.erase(tag)
	return get_tag_count(tag)
