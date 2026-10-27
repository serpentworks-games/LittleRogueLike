class_name EscapeAction
extends Action

func perform_action() -> bool:
	entity.get_tree().quit()
	return false
