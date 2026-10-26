class_name MovementAction
extends DirectionalAction

func perform_action(main: Main, entity: Entity) -> void:
	var destination: Vector2i = entity.grid_position + offset
	
	var map_data: MapData = main.get_map_data()
	var destination_tile: Tile = map_data.get_tile(destination)
	
	if not destination_tile or not destination_tile.is_walkable():
		return
		
	if main.get_map_data().get_blocking_entity_at_location(destination):
		return
	
	entity.move_entity(offset)
