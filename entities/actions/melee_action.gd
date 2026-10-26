class_name MeleeAction
extends DirectionalAction

func perform_action(main: Main, entity: Entity) -> void:
	var destination := Vector2i(entity.grid_position + offset)
	var target: Entity = main.get_map_data().get_blocking_entity_at_location(destination)
	
	if not target: return

	print("Attacking %s with your fluffy paws!" % target.get_entity_name())
