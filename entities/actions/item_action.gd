class_name ItemAction
extends Action

var item: Entity
var target_pos: Vector2i

func _init(entity: Entity, item: Entity, target_position = null) -> void:
	super._init(entity)
	self.item = item
	if not target_pos is Vector2i:
		target_pos = entity.grid_position
	self.target_pos = target_position
	
func get_target_actor() -> Entity:
	return get_map_data().get_actor_at_location(target_pos)
	
func perform_action() -> bool:
	if item == null:
		return false
	return item.consumable_component.activate(self)
