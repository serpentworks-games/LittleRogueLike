class_name Action
extends RefCounted

var entity: Entity

func _init(entity: Entity) -> void:
	self.entity = entity

func perform_action() -> void:
	pass

func get_map_data() -> MapData:
	return entity.map_data
