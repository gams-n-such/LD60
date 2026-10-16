extends Node3D


@onready var logic: Activatable = %Logic

func get_activatable() -> Activatable:
	return logic

func _on_logic_activation_complete(object: Activatable, actor: Node) -> void:
	test()


@onready var _mesh_node : MeshInstance3D = $Mesh
var _mesh : SphereMesh:
	get:
		return _mesh_node.mesh as SphereMesh if _mesh_node else null
var _material : StandardMaterial3D:
	get:
		return _mesh.material as StandardMaterial3D if _mesh else null

func test() -> void:
	if _material:
		_material.albedo_color = JamUtils.get_random_color()
