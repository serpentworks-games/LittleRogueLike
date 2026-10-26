class_name FighterComponent
extends Component

signal hp_changed(hp, max_hp)

var max_hp: int
var hp: int:
	set(value):
		hp = clampi(value, 0, max_hp)
		hp_changed.emit(hp, max_hp)
		if hp <= 0:
			handle_death()
var defense: int
var power: int
var death_texture: Texture
var death_color: Color

func _init(definition: FighterComponentDefinition) -> void:
	max_hp = definition.max_hp
	hp = definition.max_hp
	defense = definition.defense
	power = definition.power
	death_texture = definition.death_texture
	death_color = definition.death_color
	
func handle_death() -> void:
	var death_msg: String
	var death_msg_color: Color
	
	if get_map_data().player == entity:
		death_msg = "You have died..."
		death_msg_color = GameColors.PLAYER_DIE
		SignalBus.player_died.emit()
	else:
		death_msg = "%s has died." % entity.get_entity_name()
		death_msg_color = GameColors.ENEMY_DIE
		
	MessageLog.send_message(death_msg, death_msg_color)
	
	entity.texture = death_texture
	entity.modulate = death_color
	entity.ai_component.queue_free()
	entity.ai_component = null
	entity.entity_name = "Remains of %s" %entity.entity_name
	entity.blocks_movement = false
	get_map_data().unregister_blocking_entity(entity)
	entity.entity_type = Entity.EntityType.CORPSE
