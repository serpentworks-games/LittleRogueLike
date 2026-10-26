class_name BumpAction
extends DirectionalAction

func perform_action() -> void:
	if get_target_actor():
		MeleeAction.new(entity, offset.x, offset.y).perform_action()
	else:
		MovementAction.new(entity, offset.x, offset.y).perform_action()
