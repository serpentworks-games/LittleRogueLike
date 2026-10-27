class_name MovementAction
extends DirectionalAction

func perform_action() -> bool:
	var destination: Vector2i = get_destination()
	var map_data: MapData = get_map_data()
	var destination_tile: Tile = map_data.get_tile(destination)
	
	if not destination_tile or not destination_tile.is_walkable():
		if entity == get_map_data().player:
			MessageLog.send_message("That way is blocked.", GameColors.IMPOSSIBLE)
		return false
		
	entity.move_entity(offset)
	return true
