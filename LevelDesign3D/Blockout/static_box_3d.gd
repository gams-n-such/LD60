@tool
class_name StaticBox3D
extends StaticBody3D

func _ready() -> void:
	_update_size()
	_update_color()
	if Engine.is_editor_hint():
		EditorInterface.get_selection().selection_changed.connect(on_editor_selection_changed)
		on_editor_selection_changed()

var _shape_res : BoxShape3D:
	get:
		return %Collision.shape

var _mesh_res : BoxMesh:
	get:
		return %Mesh.mesh

var _size : Vector3 = Vector3.ONE
@export_custom(PROPERTY_HINT_NONE, "suffix:m") var size : Vector3:
	get:
		return _size
	set(new_size):
		_size = new_size
		if is_inside_tree():
			_update_size()

func _update_size() -> void:
	_shape_res.size = size
	_mesh_res.size = size

var _material_res : StandardMaterial3D:
	get:
		return _mesh_res.material

var _color : Color = Color.WHITE
@export var color : Color:
	get:
		return _color
	set(new_color):
		_color = new_color
		if is_inside_tree():
			_update_color()

func _update_color() -> void:
	if _material_res and _material_res.resource_local_to_scene:
		_material_res.albedo_color = _color

#@export var collision_res : BoxShape3D
#@export var mesh_res : BoxMesh
#region Tool

var was_selected : bool = false

func on_editor_selection_changed() -> void:
	var is_selected : bool = EditorInterface.get_selection().get_selected_nodes().has(self)
	if is_selected != was_selected:
		if not is_selected:
			consume_scale()
		was_selected = is_selected

func consume_scale() -> void:
	size = size * scale
	scale = Vector3.ONE

#endregion
