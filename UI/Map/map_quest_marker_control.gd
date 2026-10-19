class_name MapQuestMarkerControl
extends Control

@onready var marker_icon: TextureRect = %MarkerIcon
@onready var quest_name_label: Label = %QuestNameLabel

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	marker_icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	quest_name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE

func from_quest(quest: Resource) -> void:
	#quest_name_label.text = quest.resource_name
	pass
