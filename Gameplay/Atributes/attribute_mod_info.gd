class_name AttributeModInfo
extends Resource

enum ModType {
	ADD_FLAT,
	ADD_PERCENT
}

## ModifiedValue = (BaseValue * (1 + all AddPercent mods)) + all AddFlat mods
@export var mod_type : ModType
@export var mod_value : float
