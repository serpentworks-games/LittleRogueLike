class_name MapData
extends RefCounted

const TILE_TYPES = {
	"floor" = preload("res://assets/tile_definitions/tile_def_floor.tres"),
	"wall" = preload("res://assets/tile_definitions/tile_def_wall.tres")
}

var width: int
var height: int
var tiles: Array[Tile]
var entities: Array[Entity]

func _init(map_width: int, map_height: int) -> void:
	width = map_width
	height = map_height
	entities = []
	setup_tiles()

func setup_tiles() -> void:
	tiles = []
	for y in height:
		for x in width:
			var tile_pos := Vector2i(x,y)
			var tile := Tile.new(tile_pos, TILE_TYPES.wall)
			tiles.append(tile)

func get_tile(grid_pos: Vector2i) -> Tile:
	var tile_index: int = grid_to_index(grid_pos)
	if tile_index == -1:
		return null
	return tiles[tile_index]
	
func get_tile_xy(x: int, y: int) -> Tile:
	var grid_pos := Vector2i(x,y)
	return get_tile(grid_pos)
	
func grid_to_index(grid_pos: Vector2i) -> int:
	if not is_in_bounds(grid_pos):
		return -1
	return grid_pos.y * width + grid_pos.x
	
func is_in_bounds(coordinate: Vector2i) -> bool:
	return (
		0 <= coordinate.x
		and coordinate.x < width
		and 0 <= coordinate.y
		and coordinate.y < height
	)

func get_blocking_entity_at_location(grid_pos: Vector2i) -> Entity:
	for entity in entities:
		if entity.can_block_movement() and entity.grid_position == grid_pos:
			return entity
	return null
