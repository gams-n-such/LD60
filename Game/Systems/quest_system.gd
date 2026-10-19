class_name VikingQuestSystem
extends Node

var quests: Array[VikingQuestResource] = []

var _active_quests: Array[VikingQuestResource] = []
var _completed_quests: Array[VikingQuestResource] = []

func _ready() -> void:
	quests = Game.world_resource.quests.duplicate()
	_activate_available_quests()

func check_active_quests_completion() -> VikingQuestResource:
	for quest: VikingQuestResource in _active_quests.duplicate():
		if _is_target_island_nearby(quest):
			return _complete_quest(quest)
	return null

func _is_target_island_nearby(quest: VikingQuestResource) -> bool:
	for place: VikingPlaceResource in Game.acquisitionable_islands:
		if _get_place_name(place) == quest.island_name:
			return true
	return false

func _complete_quest(quest: VikingQuestResource) -> VikingQuestResource:
	_active_quests.erase(quest)
	if _completed_quests.has(quest):
		return null
	_completed_quests.append(quest)
	_activate_available_quests()
	return quest

func _activate_available_quests() -> void:
	for quest: VikingQuestResource in quests:
		if _active_quests.has(quest):
			continue
		if _completed_quests.has(quest):
			continue
		if _has_completed_prerequisite(quest):
			_active_quests.append(quest)

func _has_completed_prerequisite(quest: VikingQuestResource) -> bool:
	if quest.prerequisite == null:
		return true
	return _completed_quests.has(quest.prerequisite)

func _get_place_name(place: VikingPlaceResource) -> String:
	if place.is_rune():
		return place.rune.name
	return place.island.name
