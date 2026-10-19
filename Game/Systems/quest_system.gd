class_name VikingQuestSystem
extends Node

var quests: Array[VikingQuestResource] = []

var active_quests: Array[VikingQuestResource] = []
var completed_quests: Array[VikingQuestResource] = []
var completed_loki_quest : bool = false

func _ready() -> void:
	quests = Game.world_resource.quests.duplicate()
	_activate_available_quests()

func check_active_quests_completion() -> VikingQuestResource:
	for quest: VikingQuestResource in active_quests.duplicate():
		if _is_target_island_nearby(quest):
			return _complete_quest(quest)
	return null

func _is_target_island_nearby(quest: VikingQuestResource) -> bool:
	for place: VikingPlaceResource in Game.acquisitionable_islands:
		if _get_place_name(place) == quest.island_name:
			return true
	return false

func _complete_quest(quest: VikingQuestResource) -> VikingQuestResource:
	active_quests.erase(quest)
	if completed_quests.has(quest):
		return null
	completed_quests.append(quest)
	if quest.description.contains("He would've given it to you anyway."):
		completed_loki_quest = true
	_activate_available_quests()
	return quest

func _activate_available_quests() -> void:
	for quest: VikingQuestResource in quests:
		if active_quests.has(quest):
			continue
		if completed_quests.has(quest):
			continue
		if _has_completed_prerequisite(quest):
			active_quests.append(quest)

func _has_completed_prerequisite(quest: VikingQuestResource) -> bool:
	if quest.prerequisite == null:
		return true
	return completed_quests.has(quest.prerequisite)

func _get_place_name(place: VikingPlaceResource) -> String:
	if place.is_rune():
		return place.rune.name
	return place.island.name
