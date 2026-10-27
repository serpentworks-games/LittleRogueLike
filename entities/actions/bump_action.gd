class_name BumpAction
extends DirectionalAction

func perform_action() -> bool:
	if get_target_actor():
		return MeleeAction.new(entity, offset.x, offset.y).perform_action()
	else:
		return MovementAction.new(entity, offset.x, offset.y).perform_action()
