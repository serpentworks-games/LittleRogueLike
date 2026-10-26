class_name Entity
extends Sprite2D

var _definition: EntityDefinition

var grid_position: Vector2i:
	set(value):
		grid_position = value
		position = Grid.grid_to_world(grid_position)
		
func _init(start_position: Vector2i, entity_def: EntityDefinition) -> void:
	centered = false
	grid_position = start_position
	set_entity_type(entity_def)
	
func move_entity(move_offset: Vector2i) -> void:
	grid_position += move_offset

func set_entity_type(entity_def: EntityDefinition) -> void:
	_definition = entity_def
	texture = entity_def.texture
	modulate = entity_def.color

func can_block_movement() -> bool:
	return _definition.can_block_movement

func get_entity_name() -> StringName:
	return _definition.name
