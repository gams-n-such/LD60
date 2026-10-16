@tool
class_name CollisionProfileSetter
extends Node

# TODO: do we need a enum?
enum COLLISION_DOMAIN { NONE, _2D, _3D }

# TODO: can be removed?
@export var domain : COLLISION_DOMAIN

@export var profile_2d : CollisionProfile2D
@export var profile_3d : CollisionProfile3D
# TODO: autocompletion
@export_custom(PROPERTY_HINT_NONE, "CollisionProfile") var profile_name : StringName

var applied := false

func _enter_tree() -> void:
	domain = get_domain()
	if not Engine.is_editor_hint() and not applied:
		apply_profile_to_parent()
		applied = true

func get_domain() -> COLLISION_DOMAIN:
	if not is_inside_tree():
		return COLLISION_DOMAIN.NONE
	if get_parent() is CollisionObject2D:
		return COLLISION_DOMAIN._2D
	elif get_parent() is CollisionObject3D:
		return COLLISION_DOMAIN._3D
	else:
		return COLLISION_DOMAIN.NONE

func apply_profile_to_parent() -> void:
	if not is_inside_tree():
		return
	if get_parent() is CollisionObject2D:
		_get_profile_2d().apply_to_node(get_parent())
	elif get_parent() is CollisionObject3D:
		_get_profile_3d().apply_to_node(get_parent())
	else:
		return

func _get_profile_2d() -> CollisionProfile2D:
	return profile_2d

func _get_profile_3d() -> CollisionProfile3D:
	return profile_3d

# TODO: warnings for wrong parent nodes
# TODO: conditionally show properties
