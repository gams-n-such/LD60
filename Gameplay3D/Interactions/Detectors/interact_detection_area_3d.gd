class_name InteractDetectionArea3D
extends Area3D

# TODO: solve code duplication with detection ray and Area2D
# TODO: manage interactions here here
# TODO: Interaction accepter volume

signal target_changed(new_target : Node, old_target : Node)

signal interaction_started(object : Activatable)
signal interaction_complete(object : Activatable)
signal interaction_aborted(object : Activatable)

@export var owning_actor : Node = null

func _ready() -> void:
	if not owning_actor:
		owning_actor = owner

func can_start_interaction() -> bool:
	return current_target != null

func begin_interaction() -> void:
	if not can_start_interaction():
		return
	var activatable := find_activatable_in_target()
	if activatable:
		_active_object = activatable
		await activatable.activate(self)
		_active_object = null

func abort_interaction() -> void:
	if _active_object:
		_active_object.abort_activation(owning_actor)

#region Activatables

func find_activatable_in_target() -> Activatable:
	return JamUtils.get_activatable_from(current_target)

var _active_object : Activatable:
	get:
		return _active_object
	set(new_object):
		if _active_object:
			_unbind_signals(_active_object)
		_active_object = new_object
		if _active_object:
			_bind_signals(_active_object)

func _bind_signals(source : Activatable) -> void:
	if source:
		source.activation_started.connect(_on_object_activation_started)
		source.activation_complete.connect(_on_object_activation_complete)
		source.activation_aborted.connect(_on_object_activation_aborted)

func _unbind_signals(source : Activatable) -> void:
	if source:
		source.activation_started.disconnect(_on_object_activation_started)
		source.activation_complete.disconnect(_on_object_activation_complete)
		source.activation_aborted.disconnect(_on_object_activation_aborted)

func _on_object_activation_started(object : Activatable, actor : Node) -> void:
	if actor == owning_actor:
		interaction_started.emit(object)

func _on_object_activation_complete(object : Activatable, actor : Node) -> void:
	if actor == owning_actor:
		interaction_complete.emit(object)

func _on_object_activation_aborted(object : Activatable, actor : Node) -> void:
	if actor == owning_actor:
		interaction_aborted.emit(object)

#endregion

#region Collisions

var current_target : Node:
	get:
		return current_target
	set(new_target):
		if new_target == current_target:
			return
		var prev_target := current_target
		current_target = new_target
		target_changed.emit(new_target, prev_target)

var available_targets : Array[Node]

func _register_target(target : Node) -> void:
	if not target:
		return
	if available_targets.has(target):
		return
	if not target.is_in_group(JamUtils.group_interactable):
		push_error("_register_target() trying to register non-Interactable target " + str(target.get_path()))
		return
	available_targets.append(target)
	_update_active_target()

func _unregister_target(target : Node) -> void:
	if not available_targets.has(target):
		return
	available_targets.erase(target)
	_update_active_target()

func _update_active_target() -> void:
	current_target = find_best_target(available_targets)

func find_best_target(targets : Array[Node]) -> Node:
	if targets.is_empty():
		return null
	var result : Node = null
	# HACK:
	# var result_priority : float = 10000.0
	# TODO: implement priority, for now just use last
	result = targets.back()
	return result

# FIXME: we don't really want to enforce hierarchy between interaction areas and their targets
func _on_area_entered(area: Area3D) -> void:
	_register_target(JamUtils.find_interactable_parent(area))

func _on_area_exited(area: Area3D) -> void:
	_unregister_target(JamUtils.find_interactable_parent(area))


func _on_body_entered(body: Node3D) -> void:
	_register_target(JamUtils.find_interactable_parent(body))

func _on_body_exited(body: Node3D) -> void:
	_unregister_target(JamUtils.find_interactable_parent(body))

#endregion
