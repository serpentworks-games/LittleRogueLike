class_name DropItemAction
extends ItemAction

func perform_action() -> bool:
	if item == null:
		return false
	entity.inventory_component.drop_item(item)
	return true
