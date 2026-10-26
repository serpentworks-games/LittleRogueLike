class_name DirectionalAction
extends Action

var offset: Vector2i

func _init(dx: int, dy: int) -> void:
	offset = Vector2i(dx, dy)
	
func perform_action(main: Main, entity: Entity) -> void:
	pass
