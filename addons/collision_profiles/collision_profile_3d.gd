class_name CollisionProfile3D
extends Resource

# TODO: deduplicate
const PROFILE_SETTINGS = "addons/collision_profiles/profiles_table"

@export_category("Collision")
@export_flags_3d_physics var collision_layer
@export_flags_3d_physics var collision_mask

func apply_to_node(node : CollisionObject3D) -> void:
	node.collision_layer = collision_layer
	node.collision_mask = collision_mask

static func get_profiles_table() -> CollisionProfilesTable:
	return ProjectSettings.get_setting(PROFILE_SETTINGS, null) as CollisionProfilesTable

# TODO: autocompletion
static func from_settings(profile_name : StringName) -> CollisionProfile3D:
	var profiles_table := get_profiles_table()
	if profiles_table:
		return profiles_table.profiles_3d.get(profile_name, null)
	return null
