class_name BumpAction
extends DirectionalAction

func perform_action(main: Main, entity: Entity) -> void:
	var destination := Vector2i(entity.grid_position + offset)
	
	if main.get_map_data().get_blocking_entity_at_location(destination):
		MeleeAction.new(offset.x, offset.y).perform_action(main, entity)
	else:
		MovementAction.new(offset.x, offset.y).perform_action(main, entity)
