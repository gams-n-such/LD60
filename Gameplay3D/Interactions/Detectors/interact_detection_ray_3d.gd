class_name InteractDetectionRay3D
extends RayCast3D

# TODO: solve code duplication with detection area
# TODO: manage interactions here here
# TODO: Interaction accepter volume

signal target_changed(new_target : Node, old_target : Node)

signal interaction_started(object : Activatable)
signal interaction_complete(object : Activatable)
signal interaction_aborted(object : Activatable)

@export var owning_actor : Node = null

var current_target : Node:
	get:
		return current_target
	set(new_target):
		if new_target == current_target:
			return
		var prev_target := current_target
		current_target = new_target
		target_changed.emit(new_target, prev_target)

func _ready() -> void:
	if not owning_actor:
		owning_actor = owner


func _process(_delta: float) -> void:
	if not is_colliding():
		return
	var target := get_collider() as Node
	if current_target != target:
		current_target = target

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

# FIXME: we don't really want to enforce hierarchy between interaction areas and their targets
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
