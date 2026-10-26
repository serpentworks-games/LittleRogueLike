class_name EscapeAction
extends Action

func perform_action(main: Main, entity: Entity) -> void:
	main.get_tree().quit()
