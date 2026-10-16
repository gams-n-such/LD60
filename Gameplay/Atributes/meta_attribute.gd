# Meta Attributes are attributes that calculate their value depending on other attributes
# TODO: this class is very much WIP
@abstract
class_name MetaAttribute
extends Attribute

@abstract func get_backing_attributes() -> Array[Attribute]

func set_value(new_value : float) -> void:
	assert(false, "MetaAttributes should not be modified directly")

func add(delta : float) -> void:
	assert(false, "MetaAttributes should not be modified directly")

func _ready() -> void:
	_init_attribute()

var _initialized := false
func _init_attribute() -> void:
	if not _initialized:
		var backing_attributes := get_backing_attributes()
		for attribute in backing_attributes:
			if not attribute.is_node_ready():
				await attribute.ready
			attribute.value_changed.connect(_on_backing_attribute_changed)
		_update_cached_value(recalculate_value(), false)
		_initialized = true

func _on_backing_attribute_changed(attribute : Attribute, new_value : float, old_value : float) -> void:
	if _initialized:
		_update_cached_value(recalculate_value())

@abstract func recalculate_value() -> float
