class_name MeleeAction
extends DirectionalAction

func perform_action() -> bool:
	var target: Entity = get_target_actor()
	if not target:
		if entity == get_map_data().player:
			MessageLog.send_message("Nothing to attack", GameColors.IMPOSSIBLE)
		return false
	
	var dmg: int = entity.fighter_component.power - target.fighter_component.defense
	var atk_color: Color
	if entity == get_map_data().player:
		atk_color = GameColors.PLAYER_ATTACK
	else:
		atk_color = GameColors.ENEMY_ATTACK
	
	var atk_description: String = "%s attacks %s" %[entity.get_entity_name(), target.get_entity_name()]
	
	if dmg > 0:
		atk_description += " for %d hit points." % dmg
		MessageLog.send_message(atk_description, atk_color)
		target.fighter_component.hp -= dmg
	else:
		atk_description += " but does no damage."
		MessageLog.send_message(atk_description, atk_color)
	return true
