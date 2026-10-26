class_name EnemyAIComponent
extends AIComponent

var path: Array = []

func perform_behaviour() -> void:
	var target: Entity = get_map_data().player
	var target_grid_pos: Vector2i = target.grid_position
	var offset: Vector2i = target_grid_pos - entity.grid_position
	var distance: int = max(abs(offset.x), abs(offset.y))
	
	if get_map_data().get_tile(entity.grid_position).is_in_view:
		if distance <= 1:
			return MeleeAction.new(entity, offset.x, offset.y).perform_action()
		
		path = get_point_path_to(target_grid_pos)
		path.pop_front()
	
	if not path.is_empty():
		var destination := Vector2i(path[0])
		if get_map_data().get_blocking_entity_at_location(destination):
			return WaitAction.new(entity).perform_action()
		path.pop_front()
		var move_offset: Vector2i = destination - entity.grid_position
		return MovementAction.new(entity, move_offset.x, move_offset.y).perform_action()
	
	return WaitAction.new(entity).perform_action()
