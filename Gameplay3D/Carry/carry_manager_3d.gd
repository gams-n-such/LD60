# TODO: use the same code for 2D?
class_name CarryManager3D
extends Node


func _ready() -> void:
	assert(carry_parent_node)

func _process(delta: float) -> void:
	pass

@export var carry_parent_node : Node3D
@export var tween_time : float = 0.0

var held_item : Node3D:
	get:
		return held_item
	set(new_item):
		if new_item == held_item:
			return
		held_item = new_item
		# TODO: signals

func is_carrying() -> bool:
	return held_item != null

var _saved_parent : Node3D = null
var _saved_process_mode : Node.ProcessMode

func grab_item(item : Node3D) -> void:
	if held_item:
		return
	held_item = item
	_saved_process_mode = held_item.process_mode
	held_item.process_mode = Node.PROCESS_MODE_DISABLED
	_saved_parent = held_item.get_parent_node_3d()
	held_item.reparent(carry_parent_node, true)
	if tween_time > 0.0:
		var tweener = get_tree().create_tween()
		tweener.set_parallel(true)
		tweener.tween_property(held_item, "position", Vector3.ZERO, tween_time)
		tweener.tween_property(held_item, "rotation", Vector3.ZERO, tween_time)
		await tweener.finished
	else:
		held_item.position = Vector3.ZERO
		held_item.rotation = Vector3.ZERO

func release_item() -> Node3D:
	if not held_item:
		return null
	if _saved_parent:
		held_item.reparent(_saved_parent, true)
	else:
		held_item.reparent(get_tree().root, true)
	held_item.process_mode = _saved_process_mode
	var released_item := held_item
	held_item = null
	_saved_parent = null
	return released_item
