@tool
extends EditorPlugin

const PROFILES_SETTINGS = "addons/collision_profiles/profiles_table"

var inspector_plugin
var inspector_script = preload("res://addons/collision_profiles/inspector/collision_profile_inspector.gd")

const COLLISION_PROFILES = preload("uid://c0umnhqbsm634")

func _enter_tree() -> void:
	inspector_plugin = inspector_script.new()
	add_inspector_plugin(inspector_plugin)
	_load_or_add_settings()

func _exit_tree() -> void:
	remove_inspector_plugin(inspector_plugin)
	pass


func _load_or_add_settings() -> void:
	if not ProjectSettings.has_setting(PROFILES_SETTINGS):
		ProjectSettings.set_setting(PROFILES_SETTINGS, {})
	ProjectSettings.add_property_info({
		"name": PROFILES_SETTINGS,
		"type": TYPE_OBJECT,
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		"hint_string": "CollisionProfilesTable"
	})
