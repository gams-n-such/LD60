@tool
extends Node3D


func _ready() -> void:
	pass # Replace with function body.

@onready var player_start: Node3D = %PlayerStart
@export var map_scale : float = 1.0
@export var game_config : VikingGameConfig = null
@export var world_resource : VikingWorldResource = null
@onready var border_mesh: MeshInstance3D = %BorderMesh

@onready var islands_root: Node3D = %Islands

const EDITOR_PLACE_SCENE = preload("uid://dad2mnghcn17b")

@export_tool_button("Save to resource") var save_world := func ():
	if not world_resource:
		return
	
	world_resource.radius = maxf(border_mesh.scale.x, border_mesh.scale.z) / map_scale
	world_resource.player_start_coords = Vector2(player_start.global_position.x, player_start.global_position.z) / map_scale
	
	world_resource.places.clear()
	for child in islands_root.get_children():
		if child is VikingWorldEditorPlace3D:
			var place := child as VikingWorldEditorPlace3D
			world_resource.places.append(place.as_resource(map_scale))
	world_resource.emit_changed()
	ResourceSaver.save(world_resource)

@export_tool_button("Edit island shapes") var edit_islands := func ():
	for child in islands_root.get_children():
		set_editable_instance(child, true)

@export_tool_button("Fix island shapes") var fix_islands := func ():
	for child in islands_root.get_children():
		set_editable_instance(child, false)

@export_tool_button("Load from resource") var load_world := func ():
	for child in islands_root.get_children():
		islands_root.remove_child(child)
		child.queue_free()
	
	if not world_resource:
		return
	
	border_mesh.scale = Vector3.ONE * world_resource.radius * map_scale
	player_start.global_position = Vector3(world_resource.player_start_coords.x, 0.0, world_resource.player_start_coords.y) * map_scale
	for place in world_resource.places:
		var place_node := EDITOR_PLACE_SCENE.instantiate() as VikingWorldEditorPlace3D
		islands_root.add_child(place_node)
		place_node.owner = self
		#set_editable_instance(place_node, true)
		place_node.from_resource(place, map_scale)
