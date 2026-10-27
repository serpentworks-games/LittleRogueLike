class_name PickupAction
extends Action

func perform_action() -> bool:
	var inv: InventoryComponent = entity.inventory_component
	if not inv: return false
	
	var map_data: MapData = get_map_data()
	
	for item in map_data.get_items():
		if entity.grid_position == item.grid_position:
			if inv.items.size() >= inv.capacity:
				MessageLog.send_message(
					"Your inventory is full.",
					GameColors.IMPOSSIBLE
				)
				return false
			
			map_data.entities.erase(item)
			item.get_parent().remove_child(item)
			inv.items.append(item)
			MessageLog.send_message(
				"You picked up the %s!" % item.get_entity_name(),
				Color.WHITE
			)
			return true
			
	MessageLog.send_message("There is nothing to pick up.", GameColors.IMPOSSIBLE)
	return false
