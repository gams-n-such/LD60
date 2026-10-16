extends Node3D

@export_category("Spawner")
@export var player_scene : PackedScene

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

# HACK: single-player only
func _find_active_player() -> Node3D:
	return get_tree().get_first_node_in_group(JamUtils.group_player) as Node3D

func get_default_spawn_transform() -> Transform3D:
	return JamUtils.get_unscaled_transform_3d(global_transform)

func is_on_cooldown() -> bool:
	return not %Cooldown.is_stopped()

func start_cooldown() -> void:
	%Cooldown.start()

func respawn_player() -> void:
	if is_on_cooldown():
		return
	assert(player_scene)
	start_cooldown()
	var active_player := _find_active_player()
	if active_player:
		active_player.queue_free()
	_spawn_player_as(player_scene, get_default_spawn_transform())

func respawn_player_in_place() -> void:
	assert(player_scene)
	var active_player := _find_active_player()
	if not active_player:
		respawn_player()
		return
	var player_transform := active_player.transform
	var player_parent := active_player.get_parent()
	active_player.queue_free()
	_spawn_player_as(player_scene, player_transform, player_parent)

func _spawn_player_as(scene : PackedScene, spawn_at : Transform3D, parent_node : Node = null, make_transient : bool = true) -> Node3D:
	assert(scene)
	var spawned_player := scene.instantiate() as Node3D
	spawned_player.transform = spawn_at
	# TODO: attachment options
	if not parent_node:
		parent_node = get_tree().root
	parent_node.add_child(spawned_player)
	if make_transient:
		Game.register_transient_scene(spawned_player)
	return spawned_player
