class_name DirectionalAction
extends Action

var offset: Vector2i

func _init(entity: Entity, dx: int, dy: int) -> void:
	offset = Vector2i(dx, dy)
	super._init(entity)

func get_destination() -> Vector2i:
	return entity.grid_position + offset
	
func get_blocking_entity_at_destination() -> Entity:
	return get_map_data().get_blocking_entity_at_location(get_destination())
	
func get_target_actor() -> Entity:
	return get_map_data().get_actor_at_location(get_destination())
