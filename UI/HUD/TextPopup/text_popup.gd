class_name TextPopup
extends CanvasLayer

@onready var panel: PanelContainer = %PanelContainer
@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var ok_button: Button = %OkButton

func _ready() -> void:
	layer = 100
	panel.hide()
	ok_button.pressed.connect(_on_ok_pressed)
	if not Game.visiting_system.island_visited.is_connected(_on_island_visited):
		Game.visiting_system.island_visited.connect(_on_island_visited)

func _on_island_visited(place: VikingPlaceResource, quest: VikingQuestResource) -> void:
	if quest != null:
		print("Quest popup with header=%s, desc=%s" % [quest.header, quest.description])
		if quest.island_name == "SleipnirIsland" and !Game.quest_system.completed_loki_quest:
			description_label.text = "\"You place the runestones into the iron sockets on the horse's neck, and the ancient mechanisms inside begin to grind and creak. The air trembles, filled with magic. A thousand years of dust and rust fall from its mighty body, churning the sea around it into foam.

Odin's steel steed has awakened.

But just before departure, a thunderous crash erupts: Loki and Heimdall, sworn enemies, have clashed in battle. With a mighty blow, Heimdall knocks Loki off the steed, sending him plunging into the poisonous sea.

The god of lies will never return to the world of the living.\""
		else:
			description_label.text = quest.description
		title_label.text = quest.header
	else:
		if place.description == null or place.description.is_empty():
			return
		if place.description_header == null or place.description_header.is_empty():
			if place.is_rune():
				title_label.text = place.rune.name
			if place.is_island():
				title_label.text = place.island.name
		else:
			title_label.text = place.description_header
		description_label.text = place.description
	Game.pause()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	panel.show()
	ok_button.grab_focus()

func _on_ok_pressed() -> void:
	Game.unpause()
	panel.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
