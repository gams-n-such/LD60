class_name Ship
extends Node3D

@export_group("Ship Rotation")
@export var rotation_degrees_per_second : float = 15.0

@onready var ship_pivot : Node3D = %ShipPivot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if not Game.player.has_time_hud_open :
		var direction := Input.get_axis("rotate_right", "rotate_left")
		var rotation_delta := direction * rotation_degrees_per_second * delta
		ship_pivot.global_rotation_degrees.y += rotation_delta
		Game.ship_state.set_heading(ship_pivot.global_rotation_degrees.y)
