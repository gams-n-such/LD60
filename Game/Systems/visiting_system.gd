class_name VikingVisitingSystem
extends Node

signal island_visited(place: VikingPlaceResource, quest: VikingQuestResource)

var _previous_islands: Array[VikingPlaceResource] = []

func check_for_new_islands() -> void:
	var current_islands: Array[VikingPlaceResource] = Game.acquisitionable_islands
	for island in current_islands:
		if not _previous_islands.has(island):
			island_visited.emit(island, Game.quest_system.check_active_quests_completion())
	_previous_islands = current_islands.duplicate()
