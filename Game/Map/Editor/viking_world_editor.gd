@tool
extends Node2D

const EDITOR_PLACE_SCENE = preload("uid://rxnqdg3jxniu")

@export_tool_button("Edit island shapes") var edit_islands := func ():
	for child in islands_root.get_children():
		set_editable_instance(child, true)

@export_tool_button("Fix island shapes") var fix_islands := func ():
	for child in islands_root.get_children():
		set_editable_instance(child, false)

@export_tool_button("Save to resource") var save_world := func ():
	if not world_resource:
		return
	
	var border_size_px := border_inner_radius * border_sprite.scale
	world_resource.radius = maxf(border_size_px.x, border_size_px.y) / pixels_per_size_unit
	
	world_resource.places.clear()
	for child in islands_root.get_children():
		if child is VikingWorldEditorPlace:
			var place := child as VikingWorldEditorPlace
			world_resource.places.append(place.as_resource(pixels_per_size_unit))
	world_resource.emit_changed()
	ResourceSaver.save(world_resource)

@export_tool_button("Load from resource") var load_world := func ():
	for child in islands_root.get_children():
		islands_root.remove_child(child)
		child.queue_free()
	
	if not world_resource:
		return
	
	border_sprite.scale = Vector2.ONE * world_resource.radius * pixels_per_size_unit / border_inner_radius
	
	for place in world_resource.places:
		var place_node := EDITOR_PLACE_SCENE.instantiate() as VikingWorldEditorPlace
		islands_root.add_child(place_node)
		place_node.owner = self
		set_editable_instance(place_node, true)
		place_node.from_resource(place, pixels_per_size_unit)

@export var world_resource : VikingWorldResource = null

@onready var border_sprite: Sprite2D = $BorderSprite
const border_inner_radius : float = 215.0

@onready var islands_root: Node2D = %Islands

@export var pixels_per_size_unit : float = 10.0

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass
