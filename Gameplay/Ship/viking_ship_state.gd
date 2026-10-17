class_name VikingShipState
extends Node

## Sailing speed in kilometers per hour.
@export var speed_km_per_hour: float = 1.0

## Ship heading in degrees: 0 = north, 90 = east.
var heading: float = 0.0

## Global map coordinates: X = east, Y = north.
## One unit represents one kilometer.
var map_position: Vector2 = Vector2.ZERO


func set_heading(value: float) -> void:
	heading = fposmod(value, 360.0)


func get_forward() -> Vector3:
	var radians := deg_to_rad(heading)
	return Vector3(
		sin(radians),
		0.0,
		-cos(radians)
	)

func move_forward(distance: float) -> void:
	if Game.world_resource == null:
		push_error("Cannot move ship: world_resource is null.")
		return
	var radians := deg_to_rad(heading)
	var movement := Vector2(
		sin(radians),
		cos(radians)
	) * distance
	var target_position := map_position + movement
	var world_radius : float = Game.world_resource.radius
	if target_position.length() > world_radius:
		target_position = target_position.normalized() * world_radius
		print("World border reached. Clamping movement to radius: %f" % world_radius)
	map_position = target_position
	print("Ship position after move: %f, %f" % [
		map_position.x, map_position.y
	])


func sail_forward(hours: float) -> void:
	if hours < 0.0:
		push_warning("Sailing duration cannot be negative.")
		return

	var distance := speed_km_per_hour * hours
	print("Moving forward %d hours from position: %f, %f, heading: %f" % [
		hours, map_position.x, map_position.y, heading
	])
	move_forward(distance)


func set_map_position(position: Vector2) -> void:
	map_position = position
