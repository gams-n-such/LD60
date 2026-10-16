class_name Activatable
extends Node

var _current_actor : Node = null

#region Enabled

@export var enabled : bool = true

#endregion

#region UI

@export var label_text : String = "Activate"

#endregion

#region Activation
@export_category("Activation")

signal activation_started(object : Activatable, actor : Node)
signal activation_complete(object : Activatable, actor : Node)
signal activation_aborted(object : Activatable, actor : Node)

@export var activation_period : float = 1.0
var _activation_timer : SceneTreeTimer = null

# TODO: implement per-actor activations
#@export var allow_parallel_activations : bool = false

func is_instant() -> bool:
	return activation_period <= 0.0

func can_be_activated_by(actor : Node) -> bool:
	if not actor:
		return false
	if not enabled:
		return false
	if is_being_activated_by(actor):
		return false
	if is_on_cooldown_for(actor):
		return false
	if not is_instant() and is_being_activated():
		return false
	return true

func is_being_activated() -> bool:
	return _current_actor != null

func is_being_activated_by(actor : Node) -> bool:
	return _current_actor == actor

func activate(actor : Node) -> bool:
	if not can_be_activated_by(actor):
		return false
	_current_actor = actor
	activation_started.emit(self, actor)
	if not is_instant():
		_activation_timer = get_tree().create_timer(activation_period, false)
		await _activation_timer.timeout
		if not is_being_activated_by(actor):
			return false
	return _try_complete_activation(actor)

func abort_activation(actor : Node) -> bool:
	if not is_being_activated_by(actor):
		return false
	_current_actor = null
	_activation_timer.set_time_left(0.0)
	activation_aborted.emit(self, actor)
	return true

func _try_complete_activation(actor : Node) -> bool:
	if not is_being_activated_by(actor):
		return false
	_activation_timer = null
	_default_cooldown_for_actor(actor)
	_current_actor = null
	
	activation_complete.emit(self, actor)
	return true

#endregion

#region Cooldown
@export_category("Cooldown")
# TODO: implement per-actor cooldowns

signal cooldown_started(object : Activatable, actor : Node)
signal cooldown_ended(object : Activatable, actor : Node)

@export var cooldown_period : float = 0.0
var _cooldown_timer : SceneTreeTimer = null

func has_cooldown() -> bool:
	return cooldown_period > 0.0

func _default_cooldown() -> void:
	if has_cooldown():
		start_cooldown(cooldown_period, true)

func is_on_cooldown() -> bool:
	return _cooldown_timer != null

func _default_cooldown_for_actor(actor : Node) -> void:
	if has_cooldown():
		_default_cooldown()

func is_on_cooldown_for(actor : Node) -> bool:
	return is_on_cooldown()

func start_cooldown_for_actor(actor : Node, duration : float, force : bool) -> void:
	start_cooldown(duration, force)

func start_cooldown(duration : float, force : bool) -> bool:
	if duration <= 0.0:
		push_warning("Activatable::start_cooldown() called with invalid duration on node " + str(get_path()))
		return false
	if is_on_cooldown() and not force:
		return false
	_cooldown_timer = _create_cooldown_timer(duration)
	cooldown_started.emit(self, null)
	await _cooldown_timer.timeout
	reset_cooldown(true)
	return true

func reset_cooldown(emit_signals : bool) -> bool:
	if _cooldown_timer:
		# SceneTreeTimers are freed automatically
		_cooldown_timer = null
		if emit_signals:
			# TODO: per-actor cooldowns
			cooldown_ended.emit(self, null)
		return true
	return false

func _create_cooldown_timer(duration : float) -> SceneTreeTimer:
	return get_tree().create_timer(duration, false)

#endregion
