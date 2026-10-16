@abstract
class_name WeightedRandomPool
extends Resource

@abstract func get_entries() -> Array[WeightedRandomPoolEntry]

func is_empty() -> bool:
	return get_entries().is_empty()

func get_random_entry() -> WeightedRandomPoolEntry:
	var entries : Array[WeightedRandomPoolEntry] = get_entries()
	if entries.is_empty():
		return null

	var sum_weights : float = 0.0
	for entry in entries:
		if entry:
			sum_weights += entry.weight

	var rand_weight : float = randf_range(0.0, sum_weights)
	for entry in entries:
		rand_weight -= entry.weight
		if rand_weight < 0:
			return entry

	return entries[-1]

func get_random_object():
	var random_entry : WeightedRandomPoolEntry = get_random_entry()
	if random_entry:
		return random_entry.object
	else:
		return null

func get_random_entries(count : int) -> Array[WeightedRandomPoolEntry]:
	if is_empty():
		return []

	var result : Array[WeightedRandomPoolEntry] = []
	for i in count:
		result.append(get_random_entry())

	return result

func get_random_objects(count : int):
	var random_entries : Array[WeightedRandomPoolEntry] = get_random_entries(count)
	var result = random_entries.map(
		func(entry : WeightedRandomPoolEntry):
			return entry.object
	)
	return result
