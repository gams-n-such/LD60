extends EditorInspectorPlugin

const CollisionProfileProperty = preload("uid://dmgacx6with8o")

func _can_handle(_object):
	# Support all objects
	return true


func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	if type == TYPE_STRING or type == TYPE_STRING_NAME:
		if hint_string.contains("CollisionProfile"):
			var new_editor := CollisionProfileProperty.new()
			
			if hint_string.contains("CollisionProfile2D"):
				new_editor.set_domain(new_editor.COLLISION_DOMAIN._2D)
			elif hint_string.contains("CollisionProfile3D"):
				new_editor.set_domain(new_editor.COLLISION_DOMAIN._3D)
			else:
				new_editor.set_domain(new_editor.COLLISION_DOMAIN.NONE)
			
			add_property_editor(name, new_editor)
			return true
	return false
