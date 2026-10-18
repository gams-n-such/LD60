
class_name VikingLevel
extends Node3D

## How many 3D level units correspond to one map unit.
## Map coordinates remain unchanged; this only affects 3D placement.
@export_range(1, 20.0, 0.1, "or_greater")
var level_units_per_map_unit: float = 1.0
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
		var rotated_offset := map_offset.rotated(heading_radians)
		print("Rotated offset: %s" % str(rotated_offset))
		print("Ship map pos: %s" % str(ship_map_position))
		print("Ship level pos: %s" % str(ship.position))
		#var ship_local_position := to_local(ship.global_position)
		#print("Ship to_local pos: %s" % str(ship_local_position))
		var level_offset := rotated_offset * level_units_per_map_unit
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
		island_instance.rotation.y = deg_to_rad(place.heading - Game.ship_state.heading)
		island_instance.scale = Vector3(
			place.scale.x,
			1.0,
			place.scale.y
		)
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
