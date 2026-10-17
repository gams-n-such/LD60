class_name Ship
extends Node3D

@export_group("Ship Rotation")
@export var rotation_degrees_per_second : float = 15.0

@onready var ship_pivot : Node3D = %ShipPivot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	var direction := Input.get_axis("rotate_left", "rotate_right")
	ship_pivot.rotation_degrees.y += direction * rotation_degrees_per_second * delta
