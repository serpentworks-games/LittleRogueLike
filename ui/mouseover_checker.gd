extends Node2D

signal entities_focused(entity_list)

@onready var map: Map = get_parent()

func _process(_delta: float) -> void:
	var mouse_pos: Vector2 = get_local_mouse_position()
	var tile_pos: Vector2i = Grid.world_to_grid(mouse_pos)
	var entity_names = get_names_at_location(tile_pos)
	entities_focused.emit(entity_names)
	
func get_names_at_location(grid_pos: Vector2i) -> StringName:
	var entity_names := ""
	
	var map_data: MapData = map.map_data
	var tile: Tile = map_data.get_tile(grid_pos)
	
	if not tile or not tile.is_in_view:
		return entity_names
	
	var entities_at_pos: Array[Entity] = []
	for entity in map_data.entities:
		if entity.grid_position == grid_pos:
			entities_at_pos.append(entity)
	entities_at_pos.sort_custom(
		func(a,b): return a.z_index > b.z_index
	)
	if not entities_at_pos.is_empty():
		entity_names = entities_at_pos[0].get_entity_name()
		for i in range(1, entities_at_pos.size()):
			entity_names += ", %s" % entities_at_pos[i].get_entity_name()
	return entity_names
