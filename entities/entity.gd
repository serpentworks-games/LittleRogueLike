class_name Entity
extends Sprite2D

enum AIType {NONE, ENEMY}
enum EntityType {CORPSE, ITEM, ACTOR}

var _definition: EntityDefinition
var entity_name: StringName
var entity_type: EntityType:
	set(value):
		entity_type = value
		z_index = entity_type
var blocks_movement: bool
var map_data: MapData
var fighter_component: FighterComponent
var ai_component: AIComponent
var consumable_component: ConsumableComponent
var inventory_component: InventoryComponent

var grid_position: Vector2i:
	set(value):
		grid_position = value
		position = Grid.grid_to_world(grid_position)
		
func _init(map_data: MapData, start_position: Vector2i, entity_def: EntityDefinition) -> void:
	centered = false
	grid_position = start_position
	self.map_data = map_data
	set_entity_type(entity_def)

func set_entity_type(entity_def: EntityDefinition) -> void:
	_definition = entity_def
	entity_type = _definition.entity_type
	texture = entity_def.texture
	modulate = entity_def.color
	
	entity_name = _definition.name
	blocks_movement = _definition.can_block_movement
	
	match entity_def.ai_type:
		AIType.ENEMY:
			ai_component = EnemyAIComponent.new()
			add_child(ai_component)

	if entity_def.fighter_definition:
		fighter_component = FighterComponent.new(entity_def.fighter_definition)
		add_child(fighter_component)
		
	if entity_def.consumable_definition:
		if entity_def.consumable_definition is HealingConsumableComponentDefinition:
			consumable_component = HealingConsumableComponent.new(entity_def.consumable_definition)
			add_child(consumable_component)
			
	if entity_def.inventory_capacity > 0:
		inventory_component = InventoryComponent.new(entity_def.inventory_capacity)
		add_child(inventory_component)
		
func move_entity(move_offset: Vector2i) -> void:
	map_data.unregister_blocking_entity(self)
	grid_position += move_offset
	map_data.register_blocking_entity(self)

func can_block_movement() -> bool:
	return blocks_movement

func get_entity_name() -> StringName:
	return entity_name
	
func is_alive() -> bool:
	return ai_component != null
