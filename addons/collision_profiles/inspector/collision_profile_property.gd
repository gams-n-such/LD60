extends EditorProperty

# FIXME: duplicated in profile setter node
enum COLLISION_DOMAIN { NONE, _2D, _3D }


# The main control for editing the property.
var profile_selector : OptionButton = OptionButton.new()
# An internal value of the property.
var current_profile : StringName = &""
# A guard against internal changes when the property is updated.
var updating = false
# An internal value of the property.
var domain_override : COLLISION_DOMAIN = -1


func _init():
	_init_selector()
	
	# Add the control as a direct child of EditorProperty node.
	add_child(profile_selector)
	# Make sure the control is able to retain the focus.
	add_focusable(profile_selector)
	# Setup the initial state and connect to the signal to track changes.
	refresh_selection()
	
	profile_selector.item_selected.connect(_on_profile_selected)

func _init_selector() -> void:
	_refresh_options()

func _refresh_options() -> void:
	profile_selector.clear()
	var domain := _get_property_domain()
	match domain:
		COLLISION_DOMAIN._2D:
			_add_options_2d()
		COLLISION_DOMAIN._3D:
			_add_options_3d()
		COLLISION_DOMAIN.NONE:
			_add_options_2d()
			_add_options_3d()
		_:
			profile_selector.add_separator("No profiles")

func _add_options_2d() -> void:
	var options := _get_2d_profile_names()
	profile_selector.add_separator("2D profiles")
	if options.is_empty():
		profile_selector.add_separator("No profiles")
	else:
		for option in options:
			profile_selector.add_item(option)

func _add_options_3d() -> void:
	var options := _get_3d_profile_names()
	profile_selector.add_separator("3D profiles")
	if options.is_empty():
		profile_selector.add_separator("No profiles")
	else:
		for option in options:
			profile_selector.add_item(option)

func set_domain(new_domain : COLLISION_DOMAIN) -> void:
	domain_override = new_domain
	_refresh_options()

func _get_property_domain() -> COLLISION_DOMAIN:
	return domain_override
	# TODO:
	#get_edited_property()
	#return COLLISION_DOMAIN.NONE

func _get_2d_profile_names() -> Array[StringName]:
	return _get_2d_profiles().keys()

func _get_2d_profiles() -> Dictionary[StringName, CollisionProfile2D]:
	var result : Dictionary[StringName, CollisionProfile2D]
	var table := _get_profiles_table()
	if table:
		result = table.profiles_2d
	return result

func _get_3d_profile_names() -> Array[StringName]:
	return _get_3d_profiles().keys()

func _get_3d_profiles() -> Dictionary[StringName, CollisionProfile3D]:
	var result : Dictionary[StringName, CollisionProfile3D]
	var table := _get_profiles_table()
	if table:
		result = table.profiles_3d
	return result

static func _get_profiles_table() -> CollisionProfilesTable:
	# TODO: extract setting path
	return ProjectSettings.get_setting(CollisionProfile3D.PROFILE_SETTINGS, null) as CollisionProfilesTable

func _on_profile_selected(index : int) -> void:
	current_profile = profile_selector.get_item_text(index) if index >= 0 else ""
	emit_changed(get_edited_property(), current_profile)

func _on_button_pressed():
	if (updating):
		return

	refresh_selection()
	emit_changed(get_edited_property(), current_profile)


func _update_property():
	var new_value = get_edited_object()[get_edited_property()]
	if (new_value == current_profile):
		return

	updating = true
	current_profile = new_value
	refresh_selection()
	updating = false

func refresh_selection():
	if profile_selector.selected != -1 and profile_selector.text == current_profile:
		return
	
	profile_selector.select(-1)
	for profile_idx in range(profile_selector.item_count):
		if profile_selector.get_item_text(profile_idx) == current_profile:
			profile_selector.select(profile_idx)
			return
