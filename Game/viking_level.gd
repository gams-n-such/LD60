
class_name VikingLevel
extends Node3D

## How many 3D level units correspond to one map unit.
## Map coordinates remain unchanged; this only affects 3D placement.
var level_units_per_map_unit: float:
	get:
		return Game.config.miles_per_map_unit

@onready var ship: Node3D = %Ship

# Maps each world-place resource to its instantiated island node.
var _spawned_islands: Dictionary = {}


func _ready() -> void:
	Game.gameplay_level = self
	#init islands for the first time
	Game.skip_time(0.0, false)


func _process(_delta: float) -> void:
	pass


func update_nearby_islands(
	world: VikingWorldResource,
	ship_map_position: Vector2
) -> void:
	print("\n=== Updating nearby islands ===")
	print("Ship map position: ", ship_map_position)
	if world == null:
		print("ABORTED: world resource is null.")
		return
	if not is_instance_valid(ship):
		print("ABORTED: Ship node is missing or invalid.")
		return
	if world.places.is_empty():
		print("WARNING: World contains no places.")
	print("Total places in world: ", world.places.size())
	Game.acquisitionable_islands.clear()
	var nearby_places: Dictionary = {}
	for index in range(world.places.size()):
		var place: VikingPlaceResource = world.places[index]
		if place == null:
			print("SKIPPED place #%d: place resource is null." % index)
			continue
		if place.island == null:
			print(
				"SKIPPED place #%d: island resource is null." % index
			)
			continue
		if place.island.scene == null:
			print(
				"SKIPPED '%s': island scene is not assigned." %
				place.island.name
			)
			continue
		var distance := place.coordinates.distance_to(ship_map_position)
		if distance > place.visibility_range:
			print(
				"OUT OF RANGE '%s': map coordinates=%s, distance=%.2f, visibility_range=%.2f"
				% [
					place.island.name,
					str(place.coordinates),
					distance,
					place.visibility_range
				]
			)
			continue
		if distance <= place.acquisition_range:
			Game.acquisitionable_islands.append(place)
		nearby_places[place] = true
		var island_instance: Node3D = _spawned_islands.get(place) as Node3D
		var was_spawned := false
		if not is_instance_valid(island_instance):
			print("SPAWNING '%s'..." % place.island.name)
			var instance := place.island.scene.instantiate()
			island_instance = instance as Node3D
			if island_instance == null:
				print(
					"FAILED '%s': scene root is not Node3D (actual type: %s)."
					% [
						place.island.name,
						instance.get_class() if instance != null else "null"
					]
				)
				if instance != null:
					instance.free()
				continue
			add_child(island_instance)
			_spawned_islands[place] = island_instance
			was_spawned = true
		
		# Convert global map coordinates into an offset from the ship.
		var map_offset := place.coordinates - ship_map_position
		var heading_radians := deg_to_rad(Game.ship_state.heading)
		print("Heading radians: %s" % str(heading_radians))
		print("Map offset: %s" % str(map_offset))
		print("Ship map pos: %s" % str(ship_map_position))
		print("Ship level pos: %s" % str(ship.position))
		var level_offset := map_offset * level_units_per_map_unit
		print("Level offset: %s" % str(level_offset))
		var final_offset = Vector3(
			level_offset.x,
			0.0,
			level_offset.y
		)
		island_instance.position = Vector3(
			final_offset.x,
			0.0,
			final_offset.z
		)
		island_instance.rotation.y = deg_to_rad(place.heading)
		island_instance.scale = Vector3(
			place.scale.x,
			1.0,
			place.scale.y
		)
		_separate_island_from_ship(island_instance)
		var action := "SPAWNED" if was_spawned else "UPDATED"
		print(
			"%s '%s': map=%s, distance=%.2f, level_position=%s, heading=%.3f, final_offset=%s"
			% [
				action,
				place.island.name,
				str(place.coordinates),
				distance,
				str(island_instance.position),
				place.heading,
				str(final_offset)
			]
		)
	for place in _spawned_islands.keys():
		if nearby_places.has(place):
			continue
		var island_instance: Node3D = _spawned_islands[place] as Node3D
		if is_instance_valid(island_instance):
			print(
				"DESPAWNING '%s': no longer within radius."
				% place.island.name
			)
			island_instance.queue_free()
		else:
			print(
				"CLEANUP '%s': removing invalid instance reference."
				% place.island.name
			)
		_spawned_islands.erase(place)
	print(
		"=== Island update complete: %d active island references ===\n"
		% _spawned_islands.size()
	)

## Extra distance between the ship and an island after separation.
@export var island_collision_margin: float = 0.1


func _get_box_collision(node: Node) -> CollisionShape3D:
	return node.find_child("BoxCollision", true, false) as CollisionShape3D


func _get_world_aabb(collision: CollisionShape3D) -> AABB:
	var local_aabb: AABB = collision.shape.get_debug_mesh().get_aabb()
	return collision.global_transform * local_aabb

func _separate_island_from_ship(island: Node3D) -> void:
	var ship_collision := _get_box_collision(ship)
	var island_collision := _get_box_collision(island)
	if ship_collision == null or island_collision == null:
		push_warning("Cannot separate island: BoxCollision is missing.")
		return
	if not ship_collision.shape is BoxShape3D:
		push_warning("Ship BoxCollision must use BoxShape3D.")
		return
	if not island_collision.shape is BoxShape3D:
		push_warning("Island BoxCollision must use BoxShape3D.")
		return
	var ship_aabb := _get_world_aabb(ship_collision)
	var island_aabb := _get_world_aabb(island_collision)
	# Work in the horizontal plane.
	var ship_center := ship_aabb.get_center()
	var island_center := island_aabb.get_center()
	var direction := Vector2(
		island_center.x - ship_center.x,
		island_center.z - ship_center.z
	)
	if direction.length_squared() < 0.000001:
		direction = Vector2.UP
	else:
		direction = direction.normalized()
	# Project both world-space AABBs onto the chosen horizontal direction.
	var ship_radius := _projected_aabb_radius(ship_aabb, direction)
	var island_radius := _projected_aabb_radius(island_aabb, direction)
	var center_distance := Vector2(
		island_center.x - ship_center.x,
		island_center.z - ship_center.z
	).dot(direction)
	var required_distance := ship_radius + island_radius + island_collision_margin
	if center_distance >= required_distance:
		return
	var displacement := required_distance - center_distance
	island.global_position += Vector3(
		direction.x * displacement,
		0.0,
		direction.y * displacement
	)
	print(
		"Separated island '%s' from ship by %.2f level units."
		% [island.name, displacement]
	)


func _projected_aabb_radius(
	aabb: AABB,
	direction: Vector2
) -> float:
	var half_size := aabb.size * 0.5
	return (
		abs(direction.x) * half_size.x
		+ abs(direction.y) * half_size.z
	)
